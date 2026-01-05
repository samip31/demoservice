import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/models/individual_market_place_response_model.dart';
import 'package:smartsewa/network/models/market_model.dart';
import 'package:smartsewa/network/models/market_place_upload_response_model.dart';
import 'package:smartsewa/network/services/exraServices/payment_controller.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/market_place_screen.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import '../../../core/enum.dart';

class MarketController extends GetxController {
  final paymentController = Get.put(PaymentController());

  GlobalKey<FormState> marketFormState = GlobalKey<FormState>();
  TextEditingController marketSearchController = TextEditingController();
  TextEditingController marketTitleController = TextEditingController();
  TextEditingController marketDescriptionController = TextEditingController();
  TextEditingController marketBrandController = TextEditingController();
  TextEditingController marketDeliveryChargeController =
      TextEditingController();
  TextEditingController marketPriceController = TextEditingController();
  TextEditingController marketAddressController = TextEditingController();
  TextEditingController marketNegotiableController = TextEditingController();
  TextEditingController marketContactNoController = TextEditingController();
  TextEditingController marketContactPersonController = TextEditingController();
  TextEditingController marketWarrantyPeriodController =
      TextEditingController();

  final marketPlaceResponseModel = <MarketPlaceResponseModel>[].obs;
  final marketPlaceSearchData = <MarketPlaceResponseModel>[].obs;
  final myMarketPlaceResponseModel = <MarketPlaceResponseModel>[].obs;
  final myMarketPlaceSearchData = <MarketPlaceResponseModel>[].obs;
  final individualMarketPlaceResponseModel =
      IndividualMarketPlaceResponseModel().obs;
  var isLoading = false.obs;

  final baseUrl = BaseClient().baseUrl;

  var dateTime;

  @override
  void onInit() {
    fetchMarkets();
    super.onInit();
  }

  clearValue() {
    marketAddressController.clear();
    marketBrandController.clear();
    marketContactNoController.clear();
    marketContactPersonController.clear();
    marketDeliveryChargeController.clear();
    marketDescriptionController.clear();
    marketPriceController.clear();
    marketTitleController.clear();
    marketWarrantyPeriodController.clear();
  }

  Future<void> fetchMarkets() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      // int? id = prefs.getInt("id");
      isLoading.value = true;

      final res = await http.get(
        Uri.parse("$baseUrl/api/v1/markets"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log(res.statusCode.toString());
      log("fetchMarkets :: $baseUrl/api/v1/markets");
      log(res.body);
      isLoading.value = false;
      if (res.statusCode == 200) {
        marketPlaceResponseModel.value =
            marketPlaceResponseModelFromJson(res.body);
        marketPlaceSearchData.value = marketPlaceResponseModel;
      } else {
        errorToast(msg: "Market Place fetching failed!");
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  Future<void> fetchMyMarketsPost() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      int? id = prefs.getInt("id");
      isLoading.value = true;

      final res = await http.get(
        Uri.parse("$baseUrl/api/v1/user/$id/markets"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log(res.statusCode.toString());
      log("fetchMyMarketsPost :: $baseUrl/api/v1/user/$id/markets");
      log(res.body);
      isLoading.value = false;
      if (res.statusCode == 200) {
        myMarketPlaceResponseModel.value =
            marketPlaceResponseModelFromJson(res.body);
        myMarketPlaceSearchData.value = myMarketPlaceResponseModel;
      } else {
        errorToast(msg: "Market Place fetching failed!");
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  Future<void> getInidividualMarketPlace({int? marketId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      // int? id = prefs.getInt("id");
      isLoading.value = true;

      final res = await http.get(
        Uri.parse("$baseUrl/api/v1/market/$marketId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log(res.statusCode.toString());
      log("getInidividualMarketPlace :: $baseUrl/api/v1/market/$marketId");
      log(res.body);
      isLoading.value = false;
      if (res.statusCode == 200) {
        individualMarketPlaceResponseModel.value =
            individualMarketPlaceResponseModelFromJson(res.body);
      } else {
        errorToast(msg: "Market Place details fetching failed!");
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  getDate() {
    DateTime dateTimee = DateTime.now();
    var dateTime1 =
        DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').format(dateTimee).toString();

    dateTime = DateTime.parse(dateTime1).toIso8601String();
  }

  // request secondhands / marketplace
  uploadMarketPlace({File? file, bool? isFromServiceScreen = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    getDate();
    isLoading.value = true;
    paymentController.isLoading.value = true;
    try {
      consolelog(jsonEncode(
        <String, dynamic>{
          // "serviceType": "marketplace",
          "title": marketTitleController.text,
          "brand": marketBrandController.text,
          "description": marketDescriptionController.text,
          "contactNo": marketContactNoController.text,
          "address": marketAddressController.text,
          "contactPerson": marketContactPersonController.text,
          "price": marketPriceController.text,
          "deliveryCharge": marketDeliveryChargeController.text,
          "conditions": selectedItemConditionMarketPlace.value,
          "negotiable":
              selectedNegotiableMarketPlace.value?.toLowerCase() == "yes",
          "warrantyPeriod": marketWarrantyPeriodController.text,
          "warranty": selectedWarrantyMarketPlace.value?.toLowerCase() == "yes",
          "delivery": selectedDeliveryMarketPlace.value?.toLowerCase() == "yes",
        },
      ));
      // consolelog(true);
      final response = await http.post(
        Uri.parse(
          "$baseUrl/api/v1/user/$id/markets",
        ),
        // Uri.parse(
        //   "$baseUrl/api/v1/extraPayment/${paymentController.paymentInitiateResponseModel.value.extraPaymentId}/user/$id/markets",
        // ),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: jsonEncode(
          <String, dynamic>{
            "title": marketTitleController.text,
            "brand": marketBrandController.text,
            "description": marketDescriptionController.text,
            "contactNo": marketContactNoController.text,
            "address": marketAddressController.text,
            "contactPerson": marketContactPersonController.text,
            "price": marketPriceController.text,
            "deliveryCharge": marketDeliveryChargeController.text,
            "conditions": selectedItemConditionMarketPlace.value,
            "negotiable":
                selectedNegotiableMarketPlace.value?.toLowerCase() == "yes",
            "warranty":
                selectedWarrantyMarketPlace.value?.toLowerCase() == "yes",
            "warrantyPeriod": marketWarrantyPeriodController.text,
            "delivery":
                selectedDeliveryMarketPlace.value?.toLowerCase() == "yes",
          },
        ),
      );
      isLoading.value = false;
      consolelog("uploadMarketPlace :: $baseUrl/api/v1/user/$id/markets");
      consolelog(response.statusCode);
      consolelog(response.body);
      if (response.statusCode == 201) {
        var result = marketPlaceUploadResponseModelFromJson(response.body);
        successToast(msg: "Second hand uploaded succesfully");
        uploadImage(
          file: file,
          marketId: result.marketId.toString(),
          isFromServiceScreen: isFromServiceScreen,
        );
      } else {
        // Get.back();
        paymentController.isLoading.value = false;
        errorToast(msg: "Market Place upload failed");
      }
    } catch (e) {
      // Get.back();
      paymentController.isLoading.value = false;
      isLoading.value = false;
      errorToast(msg: e.toString());
    }
  }

  editMarketPlace(
      {File? file, bool? isFromServiceScreen = false, String? marketId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    isLoading.value = true;
    try {
      consolelog(jsonEncode(
        <String, dynamic>{
          "title": marketTitleController.text,
          "brand": marketBrandController.text,
          "description": marketDescriptionController.text,
          "contactNo": marketContactNoController.text,
          "address": marketAddressController.text,
          "contactPerson": marketContactPersonController.text,
          "price": marketPriceController.text,
          "deliveryCharge": marketDeliveryChargeController.text,
          "conditions": selectedItemConditionMarketPlace.value,
          "negotiable":
              selectedNegotiableMarketPlace.value?.toLowerCase() == "yes",
          "warrantyPeriod": marketWarrantyPeriodController.text,
          "warranty": selectedWarrantyMarketPlace.value?.toLowerCase() == "yes",
          "delivery": selectedDeliveryMarketPlace.value?.toLowerCase() == "yes",
        },
      ));
      // consolelog(true);
      final response = await http.put(
        Uri.parse(
          "$baseUrl/api/v1/market/$marketId",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: jsonEncode(
          <String, dynamic>{
            // "serviceType": "marketplace",
            "title": marketTitleController.text,
            "brand": marketBrandController.text,
            "description": marketDescriptionController.text,
            "contactNo": marketContactNoController.text,
            "address": marketAddressController.text,
            "contactPerson": marketContactPersonController.text,
            "price": marketPriceController.text,
            "deliveryCharge": marketDeliveryChargeController.text,
            "conditions": selectedItemConditionMarketPlace.value,
            "negotiable":
                selectedNegotiableMarketPlace.value?.toLowerCase() == "yes",
            "warranty":
                selectedWarrantyMarketPlace.value?.toLowerCase() == "yes",
            "warrantyPeriod": marketWarrantyPeriodController.text,
            "delivery":
                selectedDeliveryMarketPlace.value?.toLowerCase() == "yes",
          },
        ),
      );
      isLoading.value = false;
      consolelog("editMarketPlace :: $baseUrl/api/v1/market/$marketId");
      consolelog(response.statusCode);
      consolelog(response.body);
      if (response.statusCode == 200) {
        // var result = marketPlaceUploadResponseModelFromJson(response.body);
        Get.back();
        fetchMyMarketsPost();
        successToast(msg: "Second hand edited succesfully");
      } else {
        errorToast(msg: "Market Place edit failed");
      }
    } catch (e) {
      isLoading.value = false;
      errorToast(msg: e.toString());
    }
  }

  Future uploadImage(
      {File? file, String? marketId, bool? isFromServiceScreen = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");

    var uri = Uri.parse('$baseUrl/api/allimg/upload/market/$marketId');
    try {
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $apptoken'
      });
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "marketPicture",
            file.path,
            contentType: MediaType('image', 'jpg'),
          ),
        );
      }

      var data = await request.send();
      var response = await http.Response.fromStream(data);
      consolelog(response.statusCode);
      consolelog(uri);
      consolelog(response.body);
      // Get.back();
      paymentController.isLoading.value = false;

      if (response.statusCode == 200) {
        var responseJson = utf8.decode(response.bodyBytes);
        consolelog('image uploaded');
        consolelog(responseJson);
        Get.offAll(() => MarketPlaceScreen(
              isFromServiceScreen: isFromServiceScreen,
            ));
        successToast(msg: "Market Place Image upload succesfully");
      } else {
        errorToast(msg: "Market Place Image upload failed");
      }
    } catch (e) {
      // Get.back();
      paymentController.isLoading.value = false;
      logger(e.toString(), loggerType: LoggerType.error);
      errorToast(msg: e.toString());
    }
  }

  updateSoldStatusMarketPlace({String? marketId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    getDate();
    // isLoading.value = true;
    try {
      final response = await http.put(
        Uri.parse(
          "$baseUrl/api/v1/$marketId/sold",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      isLoading.value = false;
      consolelog(
          "updateSoldStatusMarketPlace :: $baseUrl/api/v1/$marketId/sold");
      consolelog(response.statusCode);
      consolelog(response.body);
      isLoading.value = false;
      Get.back();
      if (response.statusCode == 200) {
        var result = marketPlaceUploadResponseModelFromJson(response.body);
        fetchMyMarketsPost();
        successToast(msg: "Sold status updated successful");
      } else {
        errorToast(msg: "Market Place upload status failed");
      }
    } catch (e) {
      Get.back();
      isLoading.value = false;
      errorToast(msg: e.toString());
    }
  }
}
