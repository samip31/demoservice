import 'package:smartsewa/network/models/categories/category_model.dart';

class Serviced {
  final int id;
  final String name;
  final Category category;
  final String? serviceImageUrl;

  Serviced({
    required this.id,
    required this.name,
    required this.category,
    this.serviceImageUrl,
  });

  factory Serviced.fromJson(Map<String, dynamic> json) {
    return Serviced(
      id: json['id'],
      name: json['name'],
      category: Category.fromJson(json['category']),
      serviceImageUrl: json['serviceImageUrl'],
    );
  }
}