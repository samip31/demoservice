import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/enum.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/models/payment_initiate_response_model.dart';
import 'package:smartsewa/network/models/payment_service_response_model.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:smartsewa/payment.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';

class PaymentController extends GetxController {
  final controller = Get.put(AuthController());
  var isLoading = false.obs;

  final paymentInitiateResponseModel = PaymentInitiateResponseModel().obs;
  final paymentServiceResponseModel = PaymentServiceResponseModel().obs;

  final TextEditingController amountField = TextEditingController();
  final TextEditingController promoCodeField = TextEditingController();

  final paymentId = 0.obs;

  final baseUrl = BaseClient().baseUrl;

  var dateTime;

  getDate() {
    DateTime dateTimee = DateTime.now();
    var dateTime1 =
        DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').format(dateTimee).toString();

    dateTime = DateTime.parse(dateTime1).toIso8601String();
  }

  Future uploadPayment({String? serviceType}) async {
    getDate();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    isLoading.value = true;
    try {
      consolelog(paymentToString(payment: selectedPaymentMethod.value));
      consolelog(getAmountForPeriod(selectedPaymentDuration.value));
      consolelog(jsonEncode(<String, dynamic>{
        "paymentType": paymentToString(payment: selectedPaymentMethod.value),
        // "subscriptionAmount": amountField.text.trim(),
        "paymentDuration":
            periodToString(period: selectedPaymentDuration.value),
        "paymentDetails": serviceType,
        "promoCode": promoCodeField.text.trim(),
      }));
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/user/$id/extraPayments/$serviceType"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: jsonEncode(
          <String, dynamic>{
            "promoCode": promoCodeField.text.trim() == ""
                ? null
                : promoCodeField.text.trim(),
            "paymentType":
                paymentToString(payment: selectedPaymentMethod.value),
            // "subscriptionAmount": amountField.text.trim(),
            "paymentDuration":
                periodToString(period: selectedPaymentDuration.value),
            "paymentDetails": serviceType,
          },
        ),
      );
      consolelog(response.statusCode);
      consolelog(
          "uploadPayment :: $baseUrl/api/v1/user/$id/extraPayments/$serviceType");
      isLoading.value = false;
      if (response.statusCode == 201) {
        consolelog(response.body);
        paymentInitiateResponseModel.value =
            paymentInitiateResponseModelFromJson(response.body);
        paymentId.value =
            paymentInitiateResponseModel.value.extraPaymentId ?? 0;
        successToast(msg: "Payment succesfully");
        return true;
      } else {
        errorToast(msg: "Error payment");
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      logger(e.toString(), loggerType: LoggerType.error);
      errorToast(msg: e.toString());
      return false;
    }
  }

  Future uploadPaymentService() async {
    getDate();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    isLoading.value = true;
    try {
      consolelog(jsonEncode(<String, dynamic>{
        "paymentType": paymentToString(payment: selectedPaymentMethod.value),
        "subscriptionAmount": amountField.text.trim(),
        "paymentDuration": periodToStringInDaysService(
            period: selectedPaymentDurationService.value),
        "paymentDetails": "Service Provider",
        "promoCode": promoCodeField.text.trim() == ""
            ? null
            : promoCodeField.text.trim(),
      }));
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/user/$id/payments"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: jsonEncode(
          <String, dynamic>{
            "promoCode": promoCodeField.text.trim() == ""
                ? null
                : promoCodeField.text.trim(),
            "paymentType":
                paymentToString(payment: selectedPaymentMethod.value),
            "subscriptionAmount": amountField.text.trim(),
            "paymentDuration": periodToStringInDaysService(
                period: selectedPaymentDurationService.value),
            "paymentDetails": "Service Provider",
          },
        ),
      );
      consolelog(response.statusCode);
      consolelog("uploadPayment :: $baseUrl/api/v1/user/$id/payments");
      isLoading.value = false;
      if (response.statusCode == 201) {
        consolelog(response.body);
        paymentServiceResponseModel.value =
            paymentServiceResponseModelFromJson(response.body);
        successToast(msg: "Payment succesfully");
        return true;
      } else {
        errorToast(msg: "Error payment");
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      logger(e.toString(), loggerType: LoggerType.error);
      errorToast(msg: e.toString());
      return false;
    }
  }

  Future uploadPaymentInitiate(
      {bool? isFromService = false, String? serviceType}) async {
    getDate();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    isLoading.value = true;
    try {
      var data = isFromService ?? false
          ? jsonEncode(
              <String, dynamic>{
                "promoCode": promoCodeField.text.trim() == ""
                    ? null
                    : promoCodeField.text.trim(),
                // "paymentType":
                //     paymentToString(payment: selectedPaymentMethod.value),
                // "subscriptionAmount": amountField.text.trim(),
                "paymentDuration": periodToStringInDaysService(
                    period: selectedPaymentDurationService.value),
              },
            )
          : jsonEncode(
              <String, dynamic>{
                "promoCode": promoCodeField.text.trim(),
                // "paymentType":
                //     paymentToString(payment: selectedPaymentMethod.value),
                // "subscriptionAmount": amountField.text.trim(),
                "paymentDuration":
                    periodToString(period: selectedPaymentDuration.value),
                "paymentDetails": serviceType,
              },
            );
      consolelog(data);
      if (isFromService ?? false) {
        consolelog(paymentToString(payment: selectedPaymentMethod.value));
        consolelog(getAmountForPeriodService(
            period: selectedPaymentDurationService.value));
      } else {
        consolelog(paymentToString(payment: selectedPaymentMethod.value));
        // consolelog(getAmountForPeriod(selectedPaymentDuration.value));
      }
      final response = await http.post(
        isFromService ?? false
            ? Uri.parse("$baseUrl/api/v1/calculate-payment-amount")
            : Uri.parse("$baseUrl/api/v1/calculate-final-amount/$serviceType"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: data,
      );
      consolelog(response.statusCode);
      consolelog(
        isFromService ?? false
            ? Uri.parse("$baseUrl/api/v1/calculate-payment-amount")
            : Uri.parse("$baseUrl/api/v1/calculate-final-amount/$serviceType"),
      );
      isLoading.value = false;
      if (response.statusCode == 200) {
        consolelog(response.body);
        // paymentInitiateResponseModel.value =
        //     paymentInitiateResponseModelFromJson(response.body);
        successToast(msg: "Initiating payment succesfully");

        return response.body;
      } else {
        errorToast(msg: "Error initiating payment or promo code error");
        return null;
      }
    } catch (e) {
      isLoading.value = false;
      logger(e.toString(), loggerType: LoggerType.error);
      errorToast(msg: e.toString());
      return null;
    }
  }
}
