// To parse this JSON data, do
//
//     final paymentServiceResponseModel = paymentServiceResponseModelFromJson(jsonString);

import 'dart:convert';

PaymentServiceResponseModel paymentServiceResponseModelFromJson(String str) =>
    PaymentServiceResponseModel.fromJson(json.decode(str));

String paymentServiceResponseModelToJson(PaymentServiceResponseModel data) =>
    json.encode(data.toJson());

class PaymentServiceResponseModel {
  int? paymentId;
  DateTime? addedDate;
  String? paymentDetails;
  DateTime? expirationDate;
  dynamic subscriptionAmount;
  dynamic finalAmount;
  String? paymentDuration;
  dynamic promoCode;
  bool? expiryCheck;

  PaymentServiceResponseModel({
    this.paymentId,
    this.addedDate,
    this.paymentDetails,
    this.expirationDate,
    this.subscriptionAmount,
    this.finalAmount,
    this.paymentDuration,
    this.promoCode,
    this.expiryCheck,
  });

  factory PaymentServiceResponseModel.fromJson(Map<String, dynamic> json) =>
      PaymentServiceResponseModel(
        paymentId: json["paymentId"],
        addedDate: json["addedDate"] == null
            ? null
            : DateTime.parse(json["addedDate"]),
        paymentDetails: json["paymentDetails"],
        expirationDate: json["expirationDate"] == null
            ? null
            : DateTime.parse(json["expirationDate"]),
        subscriptionAmount: json["subscriptionAmount"],
        finalAmount: json["finalAmount"],
        paymentDuration: json["paymentDuration"],
        promoCode: json["promoCode"],
        expiryCheck: json["expiryCheck"],
      );

  Map<String, dynamic> toJson() => {
        "paymentId": paymentId,
        "addedDate":
            "${addedDate!.year.toString().padLeft(4, '0')}-${addedDate!.month.toString().padLeft(2, '0')}-${addedDate!.day.toString().padLeft(2, '0')}",
        "paymentDetails": paymentDetails,
        "expirationDate":
            "${expirationDate!.year.toString().padLeft(4, '0')}-${expirationDate!.month.toString().padLeft(2, '0')}-${expirationDate!.day.toString().padLeft(2, '0')}",
        "subscriptionAmount": subscriptionAmount,
        "finalAmount": finalAmount,
        "paymentDuration": paymentDuration,
        "promoCode": promoCode,
        "expiryCheck": expiryCheck,
      };
}
