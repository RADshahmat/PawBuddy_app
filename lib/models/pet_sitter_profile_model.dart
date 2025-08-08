class PetSitterProfileModel {
  final String id;
  final String userId;
  final String name;
  final String bio;
  final String profileImageUrl;
  final double rating;
  final int reviewCount;
  final double pricePerDay;
  final List<String> services;
  final List<String> petTypes;
  final int experienceYears;
  final String location;
  final bool isAvailable;
  final DateTime createdAt;

  PetSitterProfileModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.pricePerDay,
    required this.services,
    required this.petTypes,
    required this.experienceYears,
    required this.location,
    required this.isAvailable,
    required this.createdAt,
  });

  factory PetSitterProfileModel.fromJson(Map<String, dynamic> json) {
    return PetSitterProfileModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      pricePerDay: json['pricePerDay']?.toDouble() ?? 0.0,
      services: List<String>.from(json['services'] ?? []),
      petTypes: List<String>.from(json['petTypes'] ?? []),
      experienceYears: json['experienceYears'] ?? 0,
      location: json['location'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'pricePerDay': pricePerDay,
      'services': services,
      'petTypes': petTypes,
      'experienceYears': experienceYears,
      'location': location,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PetSitterProfileModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? bio,
    String? profileImageUrl,
    double? rating,
    int? reviewCount,
    double? pricePerDay,
    List<String>? services,
    List<String>? petTypes,
    int? experienceYears,
    String? location,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return PetSitterProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      services: services ?? this.services,
      petTypes: petTypes ?? this.petTypes,
      experienceYears: experienceYears ?? this.experienceYears,
      location: location ?? this.location,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
