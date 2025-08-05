import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final AuthService _authService = AuthService();

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Check if user is already logged in
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final userName = prefs.getString('user_name');
      final userEmail = prefs.getString('user_email');
      final userRole = prefs.getString('user_role');
      final userPoints = prefs.getInt('user_points') ?? 0;

      print('Checking login status - userId: $userId, userRole: $userRole');

      if (userId != null && userName != null && userEmail != null && userRole != null) {
        // Create user from stored data instead of API call to avoid loading issues
        _currentUser = UserModel(
          id: userId,
          name: userName,
          email: userEmail,
          userType: _parseUserType(userRole),
          points: userPoints,
        );
        _isLoggedIn = true;
        print('User restored from storage: ${_currentUser!.name}, type: ${_currentUser!.userType}');
      } else {
        print('No stored user data found');
        _isLoggedIn = false;
      }
    } catch (e) {
      print('Error checking login status: $e');
      _errorMessage = 'Failed to check login status';
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password, {bool isRescueTeam = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password, isRescueTeam: isRescueTeam);

      if (user != null) {
        // Validate user type matches login type
        if (isRescueTeam && user.userType != UserType.rescueTeam) {
          _errorMessage = 'Please use rescue team login for rescue accounts';
          _isLoading = false;
          notifyListeners();
          return false;
        }

        if (!isRescueTeam && user.userType == UserType.rescueTeam) {
          _errorMessage = 'Rescue teams should use rescue team login';
          _isLoading = false;
          notifyListeners();
          return false;
        }

        _currentUser = user;
        _isLoggedIn = true;
        await _saveLoginCredentials(user);
        print('Login successful: ${user.name}, type: ${user.userType}');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
      }
    } catch (e) {
      print('Login error: $e');
      _errorMessage = 'Login failed: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signup(String name, String email, String password, UserType userType) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signup(name, email, password, userType);

      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        await _saveLoginCredentials(user);
        print('Signup successful: ${user.name}, type: ${user.userType}');
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Signup error: $e');
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    _errorMessage = null;
    await _clearLoginCredentials();
    notifyListeners();
  }

  Future<void> _saveLoginCredentials(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_role', _userTypeToString(user.userType));
    await prefs.setInt('user_points', user.points);

    print('Saved user credentials: ${user.name}, role: ${_userTypeToString(user.userType)}');
  }

  Future<void> _clearLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_role');
    await prefs.remove('user_points');
    print('Cleared user credentials');
  }

  void addPoints(int points) {
    if (_currentUser != null && _currentUser!.userType != UserType.normal) {
      _currentUser = _currentUser!.copyWith(points: _currentUser!.points + points);
      _saveLoginCredentials(_currentUser!); // Update stored data
      notifyListeners();
    }
  }

  Future<bool> upgradeToPremium() async {
    if (_currentUser != null && _currentUser!.userType == UserType.normal) {
      try {
        // Call BDApps subscription service here
        final success = await _authService.subscribeToPremium(_currentUser!.id);

        if (success) {
          _currentUser = _currentUser!.copyWith(userType: UserType.premium);
          await _saveLoginCredentials(_currentUser!);
          notifyListeners();
          return true;
        }
      } catch (e) {
        print('Premium upgrade error: $e');
        _errorMessage = 'Premium upgrade failed';
        notifyListeners();
      }
    }
    return false;
  }

  UserType _parseUserType(String role) {
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

  String _userTypeToString(UserType userType) {
    switch (userType) {
      case UserType.rescueTeam:
        return 'rescueteam';
      case UserType.premium:
        return 'premium';
      case UserType.normal:
      default:
        return 'user';
    }
  }
}
