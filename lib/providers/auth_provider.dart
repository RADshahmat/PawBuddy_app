import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/bdapps_service.dart';

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
  final BDAppsService _bdAppsService = BDAppsService();

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
      final userPhone = prefs.getString('user_phone');
      final userRole = prefs.getString('user_role');
      final userPoints = prefs.getInt('user_points') ?? 0;

      print('Checking login status - userId: $userId, userRole: $userRole');

      if (userId != null && userName != null && userEmail != null && userRole != null) {
        _currentUser = UserModel(
          id: userId,
          name: userName,
          email: userEmail,
          phoneNumber: userPhone,
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

  Future<bool> signup(
      String name,
      String email,
      String password,
      String phoneNumber,
      UserType userType, {
        String? subscriptionId,
      }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.signup(
        name, email, password, phoneNumber, userType,
        subscriptionId: subscriptionId,
      );

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

  Future<bool> upgradeToPremium() async {
    if (_currentUser != null && _currentUser!.userType == UserType.normal) {
      try {
        // Show confirmation dialog first
        return true; // This will be handled by the UI to show confirmation
      } catch (e) {
        print('Premium upgrade error: $e');
        _errorMessage = 'Premium upgrade failed';
        notifyListeners();
      }
    }
    return false;
  }

  Future<bool> confirmPremiumUpgrade(String phoneNumber) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Send OTP via BDApps
      final otpResult = await _bdAppsService.sendOTPMock(phoneNumber);

      if (otpResult['success']) {
        _isLoading = false;
        notifyListeners();
        return true; // OTP sent successfully, UI will handle OTP verification
      } else {
        _errorMessage = otpResult['message'] ?? 'Failed to send OTP';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Premium upgrade error: $e');
      _errorMessage = 'Failed to upgrade to premium';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> completePremiumUpgrade(String subscriptionId, String phoneNumber) async {
    if (_currentUser == null) return false;

    try {
      final result = await _authService.upgradeToPremium(_currentUser!.id, subscriptionId);

      if (result['success']) {
        // Update user type to premium and phone number
        _currentUser = _currentUser!.copyWith(
          userType: UserType.premium,
          phoneNumber: phoneNumber,
        );

        // Update shared preferences with new user type and phone number
        await _saveLoginCredentials(_currentUser!);

        // Also update phone number in backend if different
        if (_currentUser!.phoneNumber != phoneNumber) {
          await _authService.updateUserPhone(_currentUser!.id, phoneNumber);
        }

        print('Premium upgrade completed successfully');
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Failed to upgrade to premium';
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Premium upgrade completion error: $e');
      _errorMessage = 'Failed to complete premium upgrade';
      notifyListeners();
      return false;
    }
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
    if (user.phoneNumber != null) {
      await prefs.setString('user_phone', user.phoneNumber!);
    }
    await prefs.setString('user_role', _userTypeToString(user.userType));
    await prefs.setInt('user_points', user.points);

    print('Saved user credentials: ${user.name}, role: ${_userTypeToString(user.userType)}');
  }

  Future<void> _clearLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');
    await prefs.remove('user_role');
    await prefs.remove('user_points');
    print('Cleared user credentials');
  }

  void addPoints(int points) {
    if (_currentUser != null && _currentUser!.userType != UserType.normal) {
      _currentUser = _currentUser!.copyWith(points: _currentUser!.points + points);
      _saveLoginCredentials(_currentUser!);
      notifyListeners();
    }
  }

  UserType _parseUserType(String role) {
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

  String _userTypeToString(UserType userType) {
    switch (userType) {
      case UserType.rescueTeam:
        return 'rescueteam';
      case UserType.premium:
        return 'premiumuser';
      case UserType.normal:
      default:
        return 'user';
    }
  }
}
