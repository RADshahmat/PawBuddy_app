import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import '../rescue_team/rescue_dashboard.dart';
import '../../models/user_model.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _userFormKey = GlobalKey<FormState>();
  final _rescueFormKey = GlobalKey<FormState>();

  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _rescueEmailController = TextEditingController();
  final _rescuePasswordController = TextEditingController();

  bool _userObscurePassword = true;
  bool _rescueObscurePassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _rescueEmailController.dispose();
    _rescuePasswordController.dispose();
    super.dispose();
  }

  Future<void> _login(bool isRescueTeam) async {
    final formKey = isRescueTeam ? _rescueFormKey : _userFormKey;
    final emailController = isRescueTeam ? _rescueEmailController : _userEmailController;
    final passwordController = isRescueTeam ? _rescuePasswordController : _userPasswordController;

    if (!formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearError();

    final success = await authProvider.login(
      emailController.text.trim(),
      passwordController.text,
      isRescueTeam: isRescueTeam,
    );

    if (success) {
      final user = authProvider.currentUser!;
      if (user.userType == UserType.rescueTeam) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RescueDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } else {
      final errorMessage = authProvider.errorMessage ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8D5F2),
              Color(0xFFF3E8FF),
              Color(0xFFE8D5F2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF8B5FBF),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5FBF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFF8B5FBF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF8B5FBF),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('User Login'),
                    )),
                    Tab(child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Rescue Team'),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUserLoginForm(),
                    _buildRescueLoginForm(),
                  ],
                ),
              ),

              // Sign Up Link
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupScreen()),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF8B5FBF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserLoginForm() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _userFormKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _userEmailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _userPasswordController,
                  label: 'Password',
                  icon: Icons.lock_outlined,
                  obscureText: _userObscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_userObscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _userObscurePassword = !_userObscurePassword),
                  ),
                ),
                const SizedBox(height: 30),
                _buildLoginButton(
                  onPressed: authProvider.isLoading ? null : () => _login(false),
                  isLoading: authProvider.isLoading,
                  text: 'Login as User',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRescueLoginForm() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _rescueFormKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _rescueEmailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _rescuePasswordController,
                  label: 'Password',
                  icon: Icons.lock_outlined,
                  obscureText: _rescueObscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_rescueObscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _rescueObscurePassword = !_rescueObscurePassword),
                  ),
                ),
                const SizedBox(height: 30),
                _buildLoginButton(
                  onPressed: authProvider.isLoading ? null : () => _login(true),
                  isLoading: authProvider.isLoading,
                  text: 'Login as Rescue Team',
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF8B5FBF)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: const Color(0xFF8B5FBF).withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: const Color(0xFF8B5FBF).withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF8B5FBF)),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        labelStyle: const TextStyle(color: Color(0xFF8B5FBF)),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter your $label';
        }
       /* if (label == 'Email' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'Please enter a valid email';
        } */
        return null;
      },
    );
  }

  Widget _buildLoginButton({
    required VoidCallback? onPressed,
    required bool isLoading,
    required String text,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFF8B5FBF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 8,
        ),
        child: isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
