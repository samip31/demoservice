// To parse this JSON data, do
//
//     final paymentInitiateResponseModel = paymentInitiateResponseModelFromJson(jsonString);

import 'dart:convert';

PaymentInitiateResponseModel paymentInitiateResponseModelFromJson(String str) =>
    PaymentInitiateResponseModel.fromJson(json.decode(str));

String paymentInitiateResponseModelToJson(PaymentInitiateResponseModel data) =>
    json.encode(data.toJson());

class PaymentInitiateResponseModel {
  int? extraPaymentId;
  String? paymentType;
  DateTime? expirationDate;
  DateTime? addedDate;
  dynamic subscriptionAmount;
  dynamic finalAmount;
  String? paymentDuration;
  dynamic promoCode;
  int? userId;
  String? paymentDetails;

  PaymentInitiateResponseModel({
    this.extraPaymentId,
    this.paymentType,
    this.expirationDate,
    this.addedDate,
    this.subscriptionAmount,
    this.finalAmount,
    this.paymentDuration,
    this.promoCode,
    this.userId,
    this.paymentDetails,
  });

  factory PaymentInitiateResponseModel.fromJson(Map<String, dynamic> json) =>
      PaymentInitiateResponseModel(
        extraPaymentId: json["extraPaymentId"],
        paymentType: json["paymentType"],
        expirationDate: json["expirationDate"] == null
            ? null
            : DateTime.parse(json["expirationDate"]),
        addedDate: json["addedDate"] == null
            ? null
            : DateTime.parse(json["addedDate"]),
        subscriptionAmount: json["subscriptionAmount"],
        finalAmount: json["finalAmount"],
        paymentDuration: json["paymentDuration"],
        promoCode: json["promoCode"],
        userId: json["userId"],
        paymentDetails: json["paymentDetails"],
      );

  Map<String, dynamic> toJson() => {
        "extraPaymentId": extraPaymentId,
        "paymentType": paymentType,
        "expirationDate": expirationDate?.toIso8601String(),
        "addedDate": addedDate?.toIso8601String(),
        "subscriptionAmount": subscriptionAmount,
        "finalAmount": finalAmount,
        "paymentDuration": paymentDuration,
        "promoCode": promoCode,
        "userId": userId,
        "paymentDetails": paymentDetails,
      };
}
