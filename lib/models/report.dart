import 'reports_user.dart'; // assuming you put User in a separate file

class Report {
  final String id;
  final String animalType;
  final String reportType;
  final String? description;
  final List<String> images;
  final double? price;
  final User? user;  // <-- add this

  Report({
    required this.id,
    required this.animalType,
    required this.reportType,
    required this.description,
    required this.images,
    required this.price,
    this.user,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'],
      animalType: json['animalType'] ?? '',
      reportType: json['reportType'] ?? '',
      description: json['description'],
      images: (json['photos'] as List? ?? [])
          .map((photo) => "https://pawbuddy.cse.pstu.ac.bd/uploads/reports/${photo['filename']}")
          .toList(),
      price: (json['price'] == null || json['price'] == "")
          ? null
          : double.tryParse(json['price'].toString()),
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,  // <-- parse user
    );
  }
}
