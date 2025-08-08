import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../services/bdapps_service.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../utils/app_colors.dart';

class PremiumFeatureCard {
  static void showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PremiumUpgradeDialog(),
    );
  }
}

class PremiumUpgradeDialog extends StatefulWidget {
  const PremiumUpgradeDialog({Key? key}) : super(key: key);

  @override
  State<PremiumUpgradeDialog> createState() => _PremiumUpgradeDialogState();
}

class _PremiumUpgradeDialogState extends State<PremiumUpgradeDialog> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final BDAppsService _bdAppsService = BDAppsService();

  @override
  void initState() {
    super.initState();
    _loadUserPhoneNumber();
  }

  void _loadUserPhoneNumber() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.currentUser;
    if (currentUser?.phoneNumber != null) {
      _phoneController.text = currentUser!.phoneNumber!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _startUpgradeProcess() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final phoneNumber = _phoneController.text.trim();
      final otpResult = await _bdAppsService.sendOTPMock(phoneNumber);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (otpResult['success']) {
        if (mounted) {
          Navigator.pop(context); // Close current dialog

          // Navigate to OTP verification
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                phoneNumber: phoneNumber,
                transactionId: otpResult['transactionId'],
                onOTPVerified: (otp) async {
                  await _verifyOTPAndUpgrade(
                    phoneNumber,
                    otp,
                    otpResult['transactionId'],
                  );
                },
              ),
            ),
          );
        }
      } else {
        _showErrorMessage(otpResult['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage('Error: $e');
      }
    }
  }

  Future<void> _verifyOTPAndUpgrade(
      String phoneNumber,
      String otp,
      String transactionId,
      ) async {
    try {
      final verificationResult = await _bdAppsService.verifyOTPMock(
        phoneNumber,
        otp,
        transactionId,
      );

      if (mounted) {
        Navigator.pop(context); // Close OTP screen

        if (verificationResult['success']) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final success = await authProvider.completePremiumUpgrade(
            verificationResult['subscriptionId'],
            phoneNumber,
          );

          if (success) {
            _showSuccessMessage('Successfully upgraded to Premium!');
          } else {
            _showErrorMessage('Failed to complete upgrade');
          }
        } else {
          _showErrorMessage(
              verificationResult['message'] ?? 'OTP verification failed');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close OTP screen
        _showErrorMessage('Error verifying OTP: $e');
      }
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.warning,
                  AppColors.warning.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.star,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Upgrade to Premium',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primaryLight.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎉 Premium Features:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem('🏥', 'Advanced Vet Directory'),
                  _buildFeatureItem('🤖', 'VetBot AI Assistant'),
                  _buildFeatureItem('🏠', 'Pet Shelter Services'),
                  _buildFeatureItem('🎁', 'Rewards & Gift Store'),
                  _buildFeatureItem('🏆', 'Leaderboard & Points'),
                  _buildFeatureItem('🍖', 'Animal Food Store'),
                  _buildFeatureItem('📸', 'Multiple Image Uploads'),
                  _buildFeatureItem('⭐', 'Priority Support'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                ),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Subscription Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This will charge ৳5 per day from your mobile balance. You can unsubscribe anytime from settings.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: '01712345678',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^(\+88)?01[3-9]\d{8}$').hasMatch(value!)) {
                    return 'Please enter a valid BD phone number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.warning,
                AppColors.warning.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _startUpgradeProcess,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Text(
              'Upgrade Now',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
