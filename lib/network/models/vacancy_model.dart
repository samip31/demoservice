// To parse this JSON data, do
//
//     final vacancyResponseModel = vacancyResponseModelFromJson(jsonString);

import 'dart:convert';

List<VacancyResponseModel> vacancyResponseModelFromJson(String str) =>
    List<VacancyResponseModel>.from(
        json.decode(str).map((x) => VacancyResponseModel.fromJson(x)));

String vacancyResponseModelToJson(List<VacancyResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VacancyResponseModel {
  int? vacancyId;
  String? title;
  dynamic picture;
  String? position;
  String? qualification;
  String? officeName;
  String? address;
  dynamic quantity;
  dynamic contact;
  DateTime? expirationDate;
  DateTime? addedDate;
  String? applyCvEmail;
  String? contactPerson;
  bool? statusAvailable;

  VacancyResponseModel({
    this.vacancyId,
    this.contactPerson,
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
    this.statusAvailable,
  });

  factory VacancyResponseModel.fromJson(Map<String, dynamic> json) =>
      VacancyResponseModel(
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
        contactPerson: json["contactPerson"],
        statusAvailable: json["statusAvailable"],
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
        "statusAvailable": statusAvailable,
        "contactPerson": contactPerson,
      };
}
