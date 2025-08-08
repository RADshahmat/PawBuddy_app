class PetSittingPostModel {
  final String id;
  final String userId;
  final String petName;
  final String petType;
  final String petBreed;
  final int petAge;
  final String description;
  final String petImageUrl;
  final double pricePerDay;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> requirements;
  final String location;
  final DateTime createdAt;
  final bool isActive;

  PetSittingPostModel({
    required this.id,
    required this.userId,
    required this.petName,
    required this.petType,
    required this.petBreed,
    required this.petAge,
    required this.description,
    required this.petImageUrl,
    required this.pricePerDay,
    required this.startDate,
    required this.endDate,
    required this.requirements,
    required this.location,
    required this.createdAt,
    required this.isActive,
  });

  factory PetSittingPostModel.fromJson(Map<String, dynamic> json) {
    return PetSittingPostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      petName: json['petName'] ?? '',
      petType: json['petType'] ?? '',
      petBreed: json['petBreed'] ?? '',
      petAge: json['petAge'] ?? 0,
      description: json['description'] ?? '',
      petImageUrl: json['petImageUrl'] ?? '',
      pricePerDay: json['pricePerDay']?.toDouble() ?? 0.0,
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      requirements: List<String>.from(json['requirements'] ?? []),
      location: json['location'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'petName': petName,
      'petType': petType,
      'petBreed': petBreed,
      'petAge': petAge,
      'description': description,
      'petImageUrl': petImageUrl,
      'pricePerDay': pricePerDay,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'requirements': requirements,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  PetSittingPostModel copyWith({
    String? id,
    String? userId,
    String? petName,
    String? petType,
    String? petBreed,
    int? petAge,
    String? description,
    String? petImageUrl,
    double? pricePerDay,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? requirements,
    String? location,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return PetSittingPostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      petName: petName ?? this.petName,
      petType: petType ?? this.petType,
      petBreed: petBreed ?? this.petBreed,
      petAge: petAge ?? this.petAge,
      description: description ?? this.description,
      petImageUrl: petImageUrl ?? this.petImageUrl,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      requirements: requirements ?? this.requirements,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
