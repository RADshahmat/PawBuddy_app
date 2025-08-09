import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class BDAppsService {
  static const String baseUrl = 'https://pawbuddy.cse.pstu.ac.bd/api';

  // Mock OTP sending - simulates sending OTP
  Future<Map<String, dynamic>> sendOTPMock(String phoneNumber) async {
    try {
      print('Sending mock OTP to: $phoneNumber');

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Generate mock transaction ID
      final transactionId = 'TXN_${DateTime.now().millisecondsSinceEpoch}';

      print('Mock OTP sent successfully. Transaction ID: $transactionId');

      return {
        'success': true,
        'message': 'OTP sent successfully to $phoneNumber',
        'transactionId': transactionId,
        'otp': '123456', // For testing purposes
      };
    } catch (e) {
      print('Error sending mock OTP: $e');
      return {
        'success': false,
        'message': 'Failed to send OTP: ${e.toString()}',
      };
    }
  }

  // Mock OTP verification - accepts 123456 as valid OTP
  Future<Map<String, dynamic>> verifyOTPMock(
    String phoneNumber,
    String otp,
    String transactionId,
  ) async {
    try {
      print(
        'Verifying mock OTP: $otp for phone: $phoneNumber, transaction: $transactionId',
      );

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Check if OTP is the test OTP
      if (otp == '123456') {
        final subscriptionId = 'SUB_${DateTime.now().millisecondsSinceEpoch}';

        print(
          'Mock OTP verification successful. Subscription ID: $subscriptionId',
        );

        return {
          'success': true,
          'message': 'OTP verified successfully',
          'subscriptionId': subscriptionId,
          'phoneNumber': phoneNumber,
          'transactionId': transactionId,
        };
      } else {
        print('Mock OTP verification failed. Invalid OTP: $otp');
        return {
          'success': false,
          'message': 'Invalid OTP. Please enter 123456 for testing.',
        };
      }
    } catch (e) {
      print('Error verifying mock OTP: $e');
      return {
        'success': false,
        'message': 'OTP verification failed: ${e.toString()}',
      };
    }
  }

  // Real OTP sending method (for future implementation)
  Future<Map<String, dynamic>> sendOTP(String phoneNumber) async {
    try {
      // This would be the actual API call to BDApps
      final url = '$baseUrl/request-otp';
      print('Sending OTP request to: $url');

      final response = await http.post(
        Uri.parse('$baseUrl/request-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_mobile': phoneNumber}),
      );
      return jsonDecode(response.body);
      // For now, return mock response
      //return await sendOTPMock(phoneNumber);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Real OTP verification method (for future implementation)
  Future<Map<String, dynamic>> verifyOTP(
    String phoneNumber,
    String otp,
    String transactionId,
  ) async {
    try {
      // This would be the actual API call to BDApps
      final response = await http.post(
        Uri.parse('$baseUrl/otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'otp': otp,
          'referenceNo': transactionId,
        }),
      );
      return jsonDecode(response.body);
      // For now, return mock response
      //return await verifyOTPMock(phoneNumber, otp, transactionId);
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  // Subscription management methods
  Future<Map<String, dynamic>> createSubscription(
    String phoneNumber,
    String subscriptionId,
  ) async {
    try {
      // Simulate subscription creation
      await Future.delayed(const Duration(milliseconds: 500));

      return {
        'success': true,
        'message': 'Subscription created successfully',
        'subscriptionId': subscriptionId,
        'status': 'active',
        'dailyCharge': 5.0,
        'currency': 'BDT',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create subscription: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> cancelSubscription(String subscriptionId) async {
    try {
      // Simulate subscription cancellation
      await Future.delayed(const Duration(milliseconds: 500));

      return {
        'success': true,
        'message': 'Subscription cancelled successfully',
        'subscriptionId': subscriptionId,
        'status': 'cancelled',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to cancel subscription: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> getSubscriptionStatus(
    String subscriptionId,
  ) async {
    try {
      // Simulate getting subscription status
      await Future.delayed(const Duration(milliseconds: 300));

      return {
        'success': true,
        'subscriptionId': subscriptionId,
        'status': 'active',
        'dailyCharge': 5.0,
        'currency': 'BDT',
        'createdAt': DateTime.now()
            .subtract(const Duration(days: 5))
            .toIso8601String(),
        'nextChargeDate': DateTime.now()
            .add(const Duration(days: 1))
            .toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to get subscription status: ${e.toString()}',
      };
    }
  }
}
