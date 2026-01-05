// To parse this JSON data, do
//
//     final offersResponseModel = offersResponseModelFromJson(jsonString);

import 'dart:convert';

List<OffersResponseModel> offersResponseModelFromJson(String str) =>
    List<OffersResponseModel>.from(
        json.decode(str).map((x) => OffersResponseModel.fromJson(x)));

String offersResponseModelToJson(List<OffersResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OffersResponseModel {
  int? offerId;
  String? offerPicture;
  String? category;
  DateTime? expirationDate;
  DateTime? addedDate;

  OffersResponseModel({
    this.offerId,
    this.offerPicture,
    this.category,
    this.expirationDate,
    this.addedDate,
  });

  factory OffersResponseModel.fromJson(Map<String, dynamic> json) =>
      OffersResponseModel(
        offerId: json["offerId"],
        offerPicture: json["offerPicture"],
        category: json["category"],
        expirationDate: json["expirationDate"] == null
            ? null
            : DateTime.parse(json["expirationDate"]),
        addedDate: json["addedDate"] == null
            ? null
            : DateTime.parse(json["addedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "offerId": offerId,
        "offerPicture": offerPicture,
        "category": category,
        "expirationDate": expirationDate?.toIso8601String(),
        "addedDate": addedDate?.toIso8601String(),
      };
}
