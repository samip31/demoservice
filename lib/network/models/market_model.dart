// To parse this JSON data, do
//
//     final marketPlaceResponseModel = marketPlaceResponseModelFromJson(jsonString);

import 'dart:convert';

List<MarketPlaceResponseModel> marketPlaceResponseModelFromJson(String str) =>
    List<MarketPlaceResponseModel>.from(
        json.decode(str).map((x) => MarketPlaceResponseModel.fromJson(x)));

String marketPlaceResponseModelToJson(List<MarketPlaceResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MarketPlaceResponseModel {
  int? marketId;
  String? title;
  dynamic brand;
  dynamic description;
  dynamic conditions;
  bool? delivery;
  dynamic deliveryCharge;
  bool? warranty;
  dynamic warrantyPeriod;
  dynamic contactPerson;
  String? contactNo;
  String? address;
  dynamic price;
  bool? negotiable;
  DateTime? expirationDate;
  DateTime? addedDate;
  dynamic location;
  bool? sold;
  String? marketpicture;

  MarketPlaceResponseModel({
    this.marketId,
    this.title,
    this.brand,
    this.description,
    this.conditions,
    this.delivery,
    this.deliveryCharge,
    this.warranty,
    this.warrantyPeriod,
    this.contactPerson,
    this.contactNo,
    this.address,
    this.price,
    this.negotiable,
    this.expirationDate,
    this.addedDate,
    this.location,
    this.marketpicture,
    this.sold,
  });

  factory MarketPlaceResponseModel.fromJson(Map<String, dynamic> json) =>
      MarketPlaceResponseModel(
        marketId: json["marketId"],
        title: json["title"],
        brand: json["brand"],
        description: json["description"],
        conditions: json["conditions"],
        delivery: json["delivery"],
        deliveryCharge: json["deliveryCharge"],
        warranty: json["warranty"],
        warrantyPeriod: json["warrantyPeriod"],
        contactPerson: json["contactPerson"],
        contactNo: json["contactNo"],
        address: json["address"],
        price: json["price"],
        negotiable: json["negotiable"],
        expirationDate: json["expirationDate"] == null
            ? null
            : DateTime.parse(json["expirationDate"]),
        addedDate: json["addedDate"] == null
            ? null
            : DateTime.parse(json["addedDate"]),
        location: json["location"],
        marketpicture: json["marketpicture"],
        sold: json["sold"],
      );

  Map<String, dynamic> toJson() => {
        "marketId": marketId,
        "title": title,
        "brand": brand,
        "description": description,
        "conditions": conditions,
        "delivery": delivery,
        "deliveryCharge": deliveryCharge,
        "warranty": warranty,
        "warrantyPeriod": warrantyPeriod,
        "contactPerson": contactPerson,
        "contactNo": contactNo,
        "address": address,
        "price": price,
        "negotiable": negotiable,
        "expirationDate": expirationDate?.toIso8601String(),
        "addedDate": addedDate?.toIso8601String(),
        "location": location,
        "marketpicture": marketpicture,
        "sold": sold,
      };
}
