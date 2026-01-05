// To parse this JSON data, do
//
//     final individualVacancyResponseModel = individualVacancyResponseModelFromJson(jsonString);

import 'dart:convert';

IndividualVacancyResponseModel individualVacancyResponseModelFromJson(
        String str) =>
    IndividualVacancyResponseModel.fromJson(json.decode(str));

String individualVacancyResponseModelToJson(
        IndividualVacancyResponseModel data) =>
    json.encode(data.toJson());

class IndividualVacancyResponseModel {
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

  IndividualVacancyResponseModel({
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
    this.contactPerson,
  });

  factory IndividualVacancyResponseModel.fromJson(Map<String, dynamic> json) =>
      IndividualVacancyResponseModel(
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
        "contactPerson": contactPerson,
      };
}
