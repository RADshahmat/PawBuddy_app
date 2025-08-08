import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../services/bdapps_service.dart';
import '../home/home_screen.dart';
import '../rescue_team/rescue_dashboard.dart';
import 'otp_verification_screen.dart';

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
  final _userPhoneController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userConfirmPasswordController = TextEditingController();

  final _rescueNameController = TextEditingController();
  final _rescueEmailController = TextEditingController();
  final _rescuePhoneController = TextEditingController();
  final _rescuePasswordController = TextEditingController();
  final _rescueConfirmPasswordController = TextEditingController();

  bool _userObscurePassword = true;
  bool _userObscureConfirmPassword = true;
  bool _rescueObscurePassword = true;
  bool _rescueObscureConfirmPassword = true;

  // Premium selection
  bool _isPremiumSelected = false;
  bool _isProcessingOTP = false;

  final BDAppsService _bdAppsService = BDAppsService();

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
    _userPhoneController.dispose();
    _userPasswordController.dispose();
    _userConfirmPasswordController.dispose();
    _rescueNameController.dispose();
    _rescueEmailController.dispose();
    _rescuePhoneController.dispose();
    _rescuePasswordController.dispose();
    _rescueConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup(bool isRescueTeam) async {
    final formKey = isRescueTeam ? _rescueFormKey : _userFormKey;
    final nameController = isRescueTeam ? _rescueNameController : _userNameController;
    final emailController = isRescueTeam ? _rescueEmailController : _userEmailController;
    final phoneController = isRescueTeam ? _rescuePhoneController : _userPhoneController;
    final passwordController = isRescueTeam ? _rescuePasswordController : _userPasswordController;

    if (!formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearError();

    final userType = isRescueTeam ? UserType.rescueTeam :
    (_isPremiumSelected ? UserType.premium : UserType.normal);

    // If premium is selected, handle BDApps OTP flow
    if (_isPremiumSelected && !isRescueTeam) {
      await _handlePremiumSignup(
        nameController.text.trim(),
        emailController.text.trim(),
        phoneController.text.trim(),
        passwordController.text,
        userType,
      );
    } else {
      // Regular signup for free users and rescue teams
      await _performSignup(
        nameController.text.trim(),
        emailController.text.trim(),
        phoneController.text.trim(),
        passwordController.text,
        userType,
        null,
      );
    }
  }

  Future<void> _handlePremiumSignup(
      String name,
      String email,
      String phone,
      String password,
      UserType userType,
      ) async {
    setState(() {
      _isProcessingOTP = true;
    });

    try {
      // Send OTP via BDApps
      final otpResult = await _bdAppsService.sendOTPMock(phone); // Use sendOTP for production

      if (otpResult['success']) {
        setState(() {
          _isProcessingOTP = false;
        });

        // Navigate to OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              phoneNumber: phone,
              transactionId: otpResult['transactionId'],
              onOTPVerified: (otp) async {
                await _verifyOTPAndSignup(
                  name, email, phone, password, userType,
                  otp, otpResult['transactionId'],
                );
              },
            ),
          ),
        );
      } else {
        setState(() {
          _isProcessingOTP = false;
        });
        _showErrorMessage(otpResult['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      setState(() {
        _isProcessingOTP = false;
      });
      _showErrorMessage('Error sending OTP: $e');
    }
  }

  Future<void> _verifyOTPAndSignup(
      String name,
      String email,
      String phone,
      String password,
      UserType userType,
      String otp,
      String transactionId,
      ) async {
    try {
      // Verify OTP with BDApps
      final verificationResult = await _bdAppsService.verifyOTPMock(
        phone, otp, transactionId,
      ); // Use verifyOTPAndSubscribe for production

      Navigator.pop(context); // Close OTP screen

      if (verificationResult['success']) {
        // OTP verified, now signup with subscription ID
        await _performSignup(
          name, email, phone, password, userType,
          verificationResult['subscriptionId'],
        );
      } else {
        _showErrorMessage(verificationResult['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      Navigator.pop(context); // Close OTP screen
      _showErrorMessage('Error verifying OTP: $e');
    }
  }

  Future<void> _performSignup(
      String name,
      String email,
      String phone,
      String password,
      UserType userType,
      String? subscriptionId,
      ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.signup(
      name, email, password, phone, userType,
      subscriptionId: subscriptionId,
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
      _showErrorMessage(errorMessage);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
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
                  controller: _userPhoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^(\+88)?01[3-9]\d{8}$').hasMatch(value!)) {
                      return 'Please enter a valid Bangladeshi phone number';
                    }
                    return null;
                  },
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
                const SizedBox(height: 20),

                // Premium Selection
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF8B5FBF).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5FBF),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: _isPremiumSelected,
                            onChanged: (value) {
                              setState(() {
                                _isPremiumSelected = value!;
                              });
                            },
                            activeColor: const Color(0xFF8B5FBF),
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Free Account',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF8B5FBF),
                                  ),
                                ),
                                Text(
                                  'Basic features only',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _isPremiumSelected,
                            onChanged: (value) {
                              setState(() {
                                _isPremiumSelected = value!;
                              });
                            },
                            activeColor: const Color(0xFF8B5FBF),
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Premium Account',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF8B5FBF),
                                  ),
                                ),
                                Text(
                                  'All features + Points system',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                _buildSignupButton(
                  onPressed: (authProvider.isLoading || _isProcessingOTP) ? null : () => _signup(false),
                  isLoading: authProvider.isLoading || _isProcessingOTP,
                  text: _isPremiumSelected ? 'Sign Up Premium' : 'Sign Up Free',
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
                  controller: _rescuePhoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^(\+88)?01[3-9]\d{8}$').hasMatch(value!)) {
                      return 'Please enter a valid Bangladeshi phone number';
                    }
                    return null;
                  },
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
