import 'dart:convert';
import 'package:http/http.dart' as http;

class BDAppsService {
  static const String baseUrl = 'https://api.bdapps.com'; // Replace with actual BDApps API URL
  static const String apiKey = 'YOUR_BDAPPS_API_KEY'; // Replace with your actual API key

  // Send OTP for subscription
  Future<Map<String, dynamic>> sendOTP(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/subscription/send-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'serviceId': 'ANIMAL_RESCUE_PREMIUM', // Your service ID
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'transactionId': data['transactionId'],
          'message': 'OTP sent successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Verify OTP and subscribe
  Future<Map<String, dynamic>> verifyOTPAndSubscribe(
      String phoneNumber,
      String otp,
      String transactionId,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/subscription/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'otp': otp,
          'transactionId': transactionId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'subscriptionId': data['subscriptionId'],
          'message': 'Subscription activated successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid OTP or verification failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Unsubscribe from service
  Future<Map<String, dynamic>> unsubscribe(String subscriptionId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/subscription/unsubscribe'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'subscriptionId': subscriptionId,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Unsubscribed successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to unsubscribe',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Mock methods for testing
  Future<Map<String, dynamic>> sendOTPMock(String phoneNumber) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    return {
      'success': true,
      'transactionId': 'TXN_${DateTime.now().millisecondsSinceEpoch}',
      'message': 'OTP sent successfully',
    };
  }

  Future<Map<String, dynamic>> verifyOTPMock(
      String phoneNumber,
      String otp,
      String transactionId,
      ) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Accept test OTP
    if (otp == '123456') {
      return {
        'success': true,
        'subscriptionId': 'SUB_${DateTime.now().millisecondsSinceEpoch}',
        'message': 'Subscription activated successfully',
      };
    } else {
      return {
        'success': false,
        'message': 'Invalid OTP',
      };
    }
  }

  Future<Map<String, dynamic>> unsubscribeMock(String subscriptionId) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    return {
      'success': true,
      'message': 'Unsubscribed successfully',
    };
  }
}
