class VolunteerRequestModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String rescueTeamId;
  final String rescueTeamName;
  final String motivation;
  final String experience;
  final String availability;
  final List<String> skills;
  final DateTime requestDate;
  final VolunteerRequestStatus status;
  final String? rejectionReason;
  final DateTime? responseDate;

  VolunteerRequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.rescueTeamId,
    required this.rescueTeamName,
    required this.motivation,
    required this.experience,
    required this.availability,
    required this.skills,
    required this.requestDate,
    this.status = VolunteerRequestStatus.pending,
    this.rejectionReason,
    this.responseDate,
  });

  VolunteerRequestModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhone,
    String? rescueTeamId,
    String? rescueTeamName,
    String? motivation,
    String? experience,
    String? availability,
    List<String>? skills,
    DateTime? requestDate,
    VolunteerRequestStatus? status,
    String? rejectionReason,
    DateTime? responseDate,
  }) {
    return VolunteerRequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      rescueTeamId: rescueTeamId ?? this.rescueTeamId,
      rescueTeamName: rescueTeamName ?? this.rescueTeamName,
      motivation: motivation ?? this.motivation,
      experience: experience ?? this.experience,
      availability: availability ?? this.availability,
      skills: skills ?? this.skills,
      requestDate: requestDate ?? this.requestDate,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      responseDate: responseDate ?? this.responseDate,
    );
  }
}

enum VolunteerRequestStatus {
  pending,
  approved,
  rejected,
}
