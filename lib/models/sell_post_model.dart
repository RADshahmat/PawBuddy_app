class SellPostModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final double price;
  final String category;
  final List<String> imageUrls;
  final String location;
  final DateTime createdAt;
  final bool isAvailable;

  SellPostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    required this.location,
    required this.createdAt,
    required this.isAvailable,
  });

  factory SellPostModel.fromJson(Map<String, dynamic> json) {
    return SellPostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      location: json['location'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'imageUrls': imageUrls,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }

  SellPostModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    double? price,
    String? category,
    List<String>? imageUrls,
    String? location,
    DateTime? createdAt,
    bool? isAvailable,
  }) {
    return SellPostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
