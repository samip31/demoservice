// To parse this JSON data, do
//
//     final marketPlaceUploadResponseModel = marketPlaceUploadResponseModelFromJson(jsonString);

import 'dart:convert';

MarketPlaceUploadResponseModel marketPlaceUploadResponseModelFromJson(
        String str) =>
    MarketPlaceUploadResponseModel.fromJson(json.decode(str));

String marketPlaceUploadResponseModelToJson(
        MarketPlaceUploadResponseModel data) =>
    json.encode(data.toJson());

class MarketPlaceUploadResponseModel {
  int? marketId;
  String? title;
  String? brand;
  String? description;
  String? itemCondition;
  bool? delivery;
  dynamic deliveryCharge;
  bool? warranty;
  dynamic warrantyPeriod;
  String? contactPerson;
  String? contactNo;
  String? address;
  dynamic price;
  bool? negotiable;
  DateTime? expirationDate;
  DateTime? addedDate;
  dynamic location;
  dynamic marketpicture;

  MarketPlaceUploadResponseModel({
    this.marketId,
    this.title,
    this.brand,
    this.description,
    this.itemCondition,
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

  factory MarketPlaceUploadResponseModel.fromJson(Map<String, dynamic> json) =>
      MarketPlaceUploadResponseModel(
        marketId: json["marketId"],
        title: json["title"],
        brand: json["brand"],
        description: json["description"],
        itemCondition: json["itemCondition"],
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
        "itemCondition": itemCondition,
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
