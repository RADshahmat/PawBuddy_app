import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://pawbuddy.onrender.com/api/auth';

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

        final userType = _parseUserType(userData['role']);
        print('Parsed user type: $userType from role: ${userData['role']}');

        return UserModel(
          id: userData['id'].toString(),
          name: userData['username'] ?? userData['name'] ?? 'Unknown',
          email: userData['email'],
          userType: userType,
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

  Future<UserModel?> signup(String name, String email, String password, UserType userType) async {
    try {
      final String role = userType == UserType.rescueTeam ? 'rescueteam' : 'user';

      print('Attempting signup - name: $name, email: $email, role: $role');

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': name,
          'email': email,
          'password': password,
          'role': role,
        }),
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
          userType: userType,
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
          userType: _parseUserType(userData['role']),
          points: userData['points'] ?? 0,
        );
      }
    } catch (e) {
      print('Get user error: $e');
    }

    return null;
  }

  Future<bool> subscribeToPremium(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/upgrade-premium'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Premium upgrade error: $e');
      return true; // For demo purposes
    }
  }

  UserType _parseUserType(String role) {
    print('Parsing user type from role: $role');
    switch (role.toLowerCase()) {
      case 'rescueteam':
        return UserType.rescueTeam;
      case 'premium':
        return UserType.premium;
      case 'user':
      default:
        return UserType.normal;
    }
  }
}
