// To parse this JSON data, do
//
//     final servicesModel = servicesModelFromJson(jsonString);

import 'dart:convert';

List<ServicesList> servicesModelFromJson(String str) => List<ServicesList>.from(
    json.decode(str).map((x) => ServicesList.fromJson(x)));

String servicesModelToJson(List<ServicesList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServicesList {
  int? id;
  String? name;
  Category? category;
  dynamic serviceImageUrl;

  ServicesList({
    required this.id,
    required this.name,
    this.category,
    this.serviceImageUrl,
  });

  factory ServicesList.fromJson(Map<String, dynamic> json) => ServicesList(
        id: json["id"] ?? 5000,
        name: json["name"] ?? "",
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        serviceImageUrl: json["serviceImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "category": category?.toJson(),
        "serviceImageUrl": serviceImageUrl,
      };
}

class Category {
  int? categoryId;
  String? categoryTitle;
  String? categoryImg;

  Category({
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryImg,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["categoryId"],
        categoryTitle: json["categoryTitle"],
        categoryImg: json["categoryImg"],
      );

  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryTitle": categoryTitle,
      };
}

// // To parse this JSON data, do
// //
// //     final servicesResponseModel = servicesResponseModelFromJson(jsonString);

// import 'dart:convert';

// List<ServicesList> servicesResponseModelFromJson(String str) =>
//     List<ServicesList>.from(
//         json.decode(str).map((x) => ServicesList.fromJson(x)));

// String servicesResponseModelToJson(List<ServicesList> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class ServicesList {
//   int? id;
//   String? name;
//   Category? category;
//   String? serviceImageUrl;

//   ServicesList({
//     this.id,
//     this.name,
//     this.category,
//     this.serviceImageUrl,
//   });

//   factory ServicesList.fromJson(Map<String, dynamic> json) => ServicesList(
//         id: json["id"],
//         name: json["name"],
//         category: json["category"] == null
//             ? null
//             : Category.fromJson(json["category"]),
//         serviceImageUrl: json["serviceImageUrl"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "category": category?.toJson(),
//         "serviceImageUrl": serviceImageUrl,
//       };
// }

// class Category {
//   int? categoryId;
//   String? categoryTitle;
//   String? categoryImg;

//   Category({
//     this.categoryId,
//     this.categoryTitle,
//     this.categoryImg,
//   });

//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//         categoryId: json["categoryId"],
//         categoryTitle: json["categoryTitle"],
//         categoryImg: json["categoryImg"],
//       );

//   Map<String, dynamic> toJson() => {
//         "categoryId": categoryId,
//         "categoryTitle": categoryTitle,
//         "categoryImg": categoryImg,
//       };
// }
