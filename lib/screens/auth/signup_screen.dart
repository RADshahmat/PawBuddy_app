import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../home/home_screen.dart';
import '../rescue_team/rescue_dashboard.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _userFormKey = GlobalKey<FormState>();
  final _rescueFormKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userConfirmPasswordController = TextEditingController();

  final _rescueNameController = TextEditingController();
  final _rescueEmailController = TextEditingController();
  final _rescuePasswordController = TextEditingController();
  final _rescueConfirmPasswordController = TextEditingController();

  bool _userObscurePassword = true;
  bool _userObscureConfirmPassword = true;
  bool _rescueObscurePassword = true;
  bool _rescueObscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _userConfirmPasswordController.dispose();
    _rescueNameController.dispose();
    _rescueEmailController.dispose();
    _rescuePasswordController.dispose();
    _rescueConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup(bool isRescueTeam) async {
    final formKey = isRescueTeam ? _rescueFormKey : _userFormKey;
    final nameController = isRescueTeam ? _rescueNameController : _userNameController;
    final emailController = isRescueTeam ? _rescueEmailController : _userEmailController;
    final passwordController = isRescueTeam ? _rescuePasswordController : _userPasswordController;

    if (!formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearError();

    final userType = isRescueTeam ? UserType.rescueTeam : UserType.premium; // Default to premium for users

    final success = await authProvider.signup(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
      userType,
    );

    if (success) {
      if (userType == UserType.rescueTeam) {
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
      final errorMessage = authProvider.errorMessage ?? 'Signup failed';
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
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5FBF),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
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
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF8B5FBF),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('User Signup'),
                    )),
                    Tab(child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Rescue Team'),
                    )),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUserSignupForm(),
                    _buildRescueSignupForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserSignupForm() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _userFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _userNameController,
                  label: 'Full Name',
                  icon: Icons.person_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _userEmailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _userConfirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.lock_outlined,
                  obscureText: _userObscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_userObscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _userObscureConfirmPassword = !_userObscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please confirm your password';
                    }
                    if (value != _userPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _buildSignupButton(
                  onPressed: authProvider.isLoading ? null : () => _signup(false),
                  isLoading: authProvider.isLoading,
                  text: 'Sign Up as User',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRescueSignupForm() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _rescueFormKey,
            child: Column(
              children: [
                _buildTextField(
                  controller: _rescueNameController,
                  label: 'Organization Name',
                  icon: Icons.business_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _rescueEmailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _rescueConfirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.lock_outlined,
                  obscureText: _rescueObscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_rescueObscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _rescueObscureConfirmPassword = !_rescueObscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please confirm your password';
                    }
                    if (value != _rescuePasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _buildSignupButton(
                  onPressed: authProvider.isLoading ? null : () => _signup(true),
                  isLoading: authProvider.isLoading,
                  text: 'Sign Up as Rescue Team',
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
    String? Function(String?)? validator,
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
      validator: validator ?? (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter your $label';
        }
        if (label == 'Email' && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
          return 'Please enter a valid email';
        }
        if (label == 'Password' && value!.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSignupButton({
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
