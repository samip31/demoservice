// To parse this JSON data, do
//
//     final vacancyUploadResponseModel = vacancyUploadResponseModelFromJson(jsonString);

import 'dart:convert';

VacancyUploadResponseModel vacancyUploadResponseModelFromJson(String str) =>
    VacancyUploadResponseModel.fromJson(json.decode(str));

String vacancyUploadResponseModelToJson(VacancyUploadResponseModel data) =>
    json.encode(data.toJson());

class VacancyUploadResponseModel {
  int? vacancyId;
  String? title;
  String? picture;
  String? position;
  String? qualification;
  String? officeName;
  String? address;
  String? quantity;
  String? contact;
  DateTime? expirationDate;
  DateTime? addedDate;
  String? applyCvEmail;

  VacancyUploadResponseModel({
    this.vacancyId,
    this.title,
    this.picture,
    this.position,
    this.qualification,
    this.officeName,
    this.address,
    this.quantity,
    this.contact,
    this.expirationDate,
    this.addedDate,
    this.applyCvEmail,
  });

  factory VacancyUploadResponseModel.fromJson(Map<String, dynamic> json) =>
      VacancyUploadResponseModel(
        vacancyId: json["vacancyId"],
        title: json["title"],
        picture: json["picture"],
        position: json["position"],
        qualification: json["qualification"],
        officeName: json["officeName"],
        address: json["address"],
        quantity: json["quantity"],
        contact: json["contact"],
        expirationDate: json["expirationDate"] == null
            ? null
            : DateTime.parse(json["expirationDate"]),
        addedDate: json["addedDate"] == null
            ? null
            : DateTime.parse(json["addedDate"]),
        applyCvEmail: json["applyCvEmail"],
      );

  Map<String, dynamic> toJson() => {
        "vacancyId": vacancyId,
        "title": title,
        "picture": picture,
        "position": position,
        "qualification": qualification,
        "officeName": officeName,
        "address": address,
        "quantity": quantity,
        "contact": contact,
        "expirationDate": expirationDate?.toIso8601String(),
        "addedDate": addedDate?.toIso8601String(),
        "applyCvEmail": applyCvEmail,
      };
}
