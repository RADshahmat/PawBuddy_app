enum UserType { normal, premium, rescueTeam }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final UserType userType;
  final int points;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.userType,
    required this.points,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    UserType? userType,
    int? points,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      points: points ?? this.points,
    );
  }

  String get userTypeString {
    switch (userType) {
      case UserType.normal:
        return 'Normal User';
      case UserType.premium:
        return 'Premium User';
      case UserType.rescueTeam:
        return 'Rescue Team';
    }
  }

  bool get canEarnPoints => userType != UserType.normal;
  bool get canViewLeaderboard => userType == UserType.premium;
  bool get canUploadMultipleImages => userType != UserType.normal;
}
