class RescueTeamModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final double latitude;
  final double longitude;
  final String address;
  final String description;
  final String imageUrl;
  final bool isVolunteerRecruitmentOpen;
  final List<String> services;
  final String availability;
  final int totalRescues;
  final double rating;

  RescueTeamModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.description,
    required this.imageUrl,
    this.isVolunteerRecruitmentOpen = false,
    required this.services,
    required this.availability,
    this.totalRescues = 0,
    this.rating = 0.0,
  });

  RescueTeamModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    double? latitude,
    double? longitude,
    String? address,
    String? description,
    String? imageUrl,
    bool? isVolunteerRecruitmentOpen,
    List<String>? services,
    String? availability,
    int? totalRescues,
    double? rating,
  }) {
    return RescueTeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isVolunteerRecruitmentOpen: isVolunteerRecruitmentOpen ?? this.isVolunteerRecruitmentOpen,
      services: services ?? this.services,
      availability: availability ?? this.availability,
      totalRescues: totalRescues ?? this.totalRescues,
      rating: rating ?? this.rating,
    );
  }

  String get locationName {
    // This would normally convert lat/lng to location name using geocoding
    // For now, return the stored address
    return address;
  }
}
