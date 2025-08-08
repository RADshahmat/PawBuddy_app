class PetModel {
  final String id;
  final String name;
  final String type;
  final String breed;
  final int age;
  final String description;
  final String imageUrl;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime createdAt;
  final bool isAvailable;
  final List<String> requirements;
  final double pricePerDay;

  PetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.description,
    required this.imageUrl,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.createdAt,
    required this.isAvailable,
    required this.requirements,
    required this.pricePerDay,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ownerId: json['ownerId'] ?? '',
      ownerName: json['ownerName'] ?? '',
      ownerPhone: json['ownerPhone'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isAvailable: json['isAvailable'] ?? true,
      requirements: List<String>.from(json['requirements'] ?? []),
      pricePerDay: json['pricePerDay']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'description': description,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'isAvailable': isAvailable,
      'requirements': requirements,
      'pricePerDay': pricePerDay,
    };
  }
}
