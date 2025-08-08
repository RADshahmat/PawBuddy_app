import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://pawbuddy.cse.pstu.ac.bd/api/auth';

  Future<UserModel?> login(String email, String password, {bool isRescueTeam = false}) async {
    try {
      print('Attempting login for: $email, isRescueTeam: $isRescueTeam');

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': email,
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data']['user'];

        return UserModel(
          id: userData['id'].toString(),
          name: userData['username'] ?? userData['name'] ?? 'Unknown',
          email: userData['email'],
          phoneNumber: userData['phoneNumber'] ?? '01716040447',
          userType: _parseUserType(userData['role']),
          points: userData['points'] ?? 0,
        );
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<UserModel?> signup(
      String name,
      String email,
      String password,
      String phoneNumber,
      UserType userType, {
        String? subscriptionId,
      }) async {
    try {
      final String role = userType == UserType.rescueTeam ? 'rescueteam' :
      userType == UserType.premium ? 'premiumuser' : 'user';

      print('Attempting signup - name: $name, email: $email, phone: $phoneNumber, role: $role');

      final requestBody = {
        'username': name,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'role': role,
      };

      // Add subscription ID for premium users
      if (subscriptionId != null) {
        requestBody['subscriptionId'] = subscriptionId;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Signup response status: ${response.statusCode}');
      print('Signup response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final userData = data['data']['user'];

        return UserModel(
          id: userData['id'].toString(),
          name: userData['username'] ?? name,
          email: userData['email'] ?? email,
          phoneNumber: userData['phoneNumber'] ?? phoneNumber,
          userType: _parseUserType(userData['role']),
          points: userData['points'] ?? 0,
        );
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Signup failed');
      }
    } catch (e) {
      print('Signup error: $e');
      throw Exception('Network error: Unable to connect to server');
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['user'];

        return UserModel(
          id: userData['id'].toString(),
          name: userData['username'] ?? userData['name'],
          email: userData['email'],
          phoneNumber: userData['phoneNumber'],
          userType: _parseUserType(userData['role']),
          points: userData['points'] ?? 0,
        );
      }
    } catch (e) {
      print('Get user error: $e');
    }

    return null;
  }

  Future<Map<String, dynamic>> upgradeToPremium(String userId, String subscriptionId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/upgrade-premium'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'subscriptionId': subscriptionId,
        }),
      );

      print('Premium upgrade response status: ${response.statusCode}');
      print('Premium upgrade response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Successfully upgraded to premium',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to upgrade to premium',
          'error': response.body,
        };
      }
    } catch (e) {
      print('Premium upgrade error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to upgrade',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateUserPhone(String userId, String phoneNumber) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/user/$userId/phone'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
        }),
      );

      print('Update phone response status: ${response.statusCode}');
      print('Update phone response body: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Phone number updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update phone number',
        };
      }
    } catch (e) {
      print('Update phone error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to update phone',
      };
    }
  }

  UserType _parseUserType(String role) {
    print('Parsing user type from role: $role');
    switch (role.toLowerCase()) {
      case 'rescueteam':
        return UserType.rescueTeam;
      case 'premiumuser':
        return UserType.premium;
      case 'user':
      default:
        return UserType.normal;
    }
  }
}
