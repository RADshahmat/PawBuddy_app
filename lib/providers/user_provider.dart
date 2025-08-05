import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _leaderboard = [
    UserModel(id: '1', name: 'Alex Johnson', email: 'alex@demo.com', 
              userType: UserType.premium, points: 1250),
    UserModel(id: '2', name: 'Sarah Wilson', email: 'sarah@demo.com', 
              userType: UserType.premium, points: 980),
    UserModel(id: '3', name: 'Mike Brown', email: 'mike@demo.com', 
              userType: UserType.premium, points: 850),
    UserModel(id: '4', name: 'Emma Davis', email: 'emma@demo.com', 
              userType: UserType.premium, points: 720),
    UserModel(id: '5', name: 'Tom Miller', email: 'tom@demo.com', 
              userType: UserType.premium, points: 650),
  ];

  List<UserModel> get leaderboard => _leaderboard;

  void updateUserPoints(String userId, int points) {
    final index = _leaderboard.indexWhere((user) => user.id == userId);
    if (index != -1) {
      _leaderboard[index] = _leaderboard[index].copyWith(
        points: _leaderboard[index].points + points
      );
      _sortLeaderboard();
      notifyListeners();
    }
  }

  void _sortLeaderboard() {
    _leaderboard.sort((a, b) => b.points.compareTo(a.points));
  }
}
