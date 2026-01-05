// To parse this JSON data, do
//
//     final offersUploadResponseModel = offersUploadResponseModelFromJson(jsonString);

import 'dart:convert';

OffersUploadResponseModel offersUploadResponseModelFromJson(String str) =>
    OffersUploadResponseModel.fromJson(json.decode(str));

String offersUploadResponseModelToJson(OffersUploadResponseModel data) =>
    json.encode(data.toJson());

class OffersUploadResponseModel {
  int? offerId;
  dynamic offerPicture;
  String? title;
  DateTime? expirationDate;
  DateTime? addedDate;

  OffersUploadResponseModel({
    this.offerId,
    this.offerPicture,
    this.title,
    this.expirationDate,
    this.addedDate,
  });

  factory OffersUploadResponseModel.fromJson(Map<String, dynamic> json) =>
      OffersUploadResponseModel(
        offerId: json["offerId"],
        offerPicture: json["offerPicture"],
        title: json["title"],
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
        "title": title,
        "expirationDate": expirationDate?.toIso8601String(),
        "addedDate": addedDate?.toIso8601String(),
      };
}
