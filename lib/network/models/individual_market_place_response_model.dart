// To parse this JSON data, do
//
//     final individualMarketPlaceResponseModel = individualMarketPlaceResponseModelFromJson(jsonString);

import 'dart:convert';

IndividualMarketPlaceResponseModel individualMarketPlaceResponseModelFromJson(
        String str) =>
    IndividualMarketPlaceResponseModel.fromJson(json.decode(str));

String individualMarketPlaceResponseModelToJson(
        IndividualMarketPlaceResponseModel data) =>
    json.encode(data.toJson());

class IndividualMarketPlaceResponseModel {
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
  String? marketpicture;

  IndividualMarketPlaceResponseModel({
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
  });

  factory IndividualMarketPlaceResponseModel.fromJson(
          Map<String, dynamic> json) =>
      IndividualMarketPlaceResponseModel(
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
      };
}
