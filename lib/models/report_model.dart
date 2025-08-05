class ReportModel {
  final String id;
  final String userId;
  final String animalType;
  final String condition;
  final String description;
  final double latitude;
  final double longitude;
  final String locationAddress;
  final List<String> imageUrls;
  final DateTime reportedAt;
  final String status; // 'pending', 'in_progress', 'completed'
  final String? assignedRescueTeamId;

  ReportModel({
    required this.id,
    required this.userId,
    required this.animalType,
    required this.condition,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.locationAddress,
    required this.imageUrls,
    required this.reportedAt,
    this.status = 'pending',
    this.assignedRescueTeamId,
  });

  ReportModel copyWith({
    String? id,
    String? userId,
    String? animalType,
    String? condition,
    String? description,
    double? latitude,
    double? longitude,
    String? locationAddress,
    List<String>? imageUrls,
    DateTime? reportedAt,
    String? status,
    String? assignedRescueTeamId,
  }) {
    return ReportModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      animalType: animalType ?? this.animalType,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationAddress: locationAddress ?? this.locationAddress,
      imageUrls: imageUrls ?? this.imageUrls,
      reportedAt: reportedAt ?? this.reportedAt,
      status: status ?? this.status,
      assignedRescueTeamId: assignedRescueTeamId ?? this.assignedRescueTeamId,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }
}
