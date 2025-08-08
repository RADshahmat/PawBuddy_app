class PetSitterModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String bio;
  final List<String> services;
  final List<String> petTypes;
  final double pricePerDay;
  final double latitude;
  final double longitude;
  final String address;
  final bool isAvailable;
  final int experienceYears;
  final List<String> certifications;
  final DateTime joinedDate;

  PetSitterModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.bio,
    required this.services,
    required this.petTypes,
    required this.pricePerDay,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.isAvailable,
    required this.experienceYears,
    required this.certifications,
    required this.joinedDate,
  });

  factory PetSitterModel.fromJson(Map<String, dynamic> json) {
    return PetSitterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      bio: json['bio'] ?? '',
      services: List<String>.from(json['services'] ?? []),
      petTypes: List<String>.from(json['petTypes'] ?? []),
      pricePerDay: json['pricePerDay']?.toDouble() ?? 0.0,
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      experienceYears: json['experienceYears'] ?? 0,
      certifications: List<String>.from(json['certifications'] ?? []),
      joinedDate: DateTime.parse(json['joinedDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'bio': bio,
      'services': services,
      'petTypes': petTypes,
      'pricePerDay': pricePerDay,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'isAvailable': isAvailable,
      'experienceYears': experienceYears,
      'certifications': certifications,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }
}
