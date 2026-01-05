// To parse this JSON data, do
//
//     final serviceProviderDetailModel = serviceProviderDetailModelFromJson(jsonString);

import 'dart:convert';

ServiceProviderDetailModel serviceProviderDetailModelFromJson(String str) =>
    ServiceProviderDetailModel.fromJson(json.decode(str));

String serviceProviderDetailModelToJson(ServiceProviderDetailModel data) =>
    json.encode(data.toJson());

class ServiceProviderDetailModel {
  ServiceProviderDetailModel({
    required this.serviceProvided,
    required this.lastName,
    required this.firstName,
  });

  String serviceProvided;
  String lastName;
  String firstName;

  factory ServiceProviderDetailModel.fromJson(Map<String, dynamic> json) =>
      ServiceProviderDetailModel(
        serviceProvided: json["serviceProvided"]??"",
        lastName: json["lastName"],
        firstName: json["firstName"],
      );

  Map<String, dynamic> toJson() => {
        "serviceProvided": serviceProvided,
        "lastName": lastName,
        "firstName": firstName,
      };
}
