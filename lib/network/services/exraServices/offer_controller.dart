// import 'dart:convert';
// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smartsewa/network/base_client.dart';
// import 'package:smartsewa/network/models/offer_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:smartsewa/views/serviceProviderScreen/drawerScreen/offer_subscription.dart';

// class OfferController extends GetxController {
//   final offers = <OfferModel>[].obs;
//   var isLoading = false.obs;
//   final baseUrl = BaseClient().baseUrl;
//   @override
//   void onInit() {
//     fetchOffers();
//     super.onInit();
//   }

//   fetchOffers() async {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? apptoken = prefs.getString("token");
//     int? id = prefs.getInt("id");
//     isLoading.value = true;
//     final res = await http.get(
//       Uri.parse("$baseUrl/api/v1/offers"),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': "Bearer $apptoken"
//       },
//     );
//     log(res.statusCode.toString());
//     if (res.statusCode == 200) {
//       final List<dynamic> data = json.decode(res.body);
//       offers.value = data.map((item) => OfferModel.fromJson(item)).toList();

//       log(res.body);
//     } else {
//       isLoading.value = false;
//       print('error');
//     }

//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/enum.dart';
import 'package:smartsewa/network/models/offer_upload_response_model.dart';
import 'package:smartsewa/network/services/exraServices/payment_controller.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/offer.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import '../../base_client.dart';
import '../../models/offer_model.dart';
import '../authServices/auth_controller.dart';
import 'package:http_parser/http_parser.dart';

class OfferController extends GetxController {
  final controller = Get.put(AuthController());
  final paymentController = Get.put(PaymentController());
  // var extraServices = <OfferModel>[].obs;
  // var myOffers = <OfferModel>[].obs;
  // var myVacancies = <OfferModel>[].obs;
  // var mySecondHands = <OfferModel>[].obs;
  final offersResponseModel = <OffersResponseModel>[].obs;
  final offersSearchData = <OffersResponseModel>[].obs;
  final myOffersResponseModel = <OffersResponseModel>[].obs;
  final myOffersSearchData = <OffersResponseModel>[].obs;
  var isLoading = false.obs;
  int? paymentId;

  final baseUrl = BaseClient().baseUrl;
  var dateTime;

  GlobalKey<FormState> offerFormState = GlobalKey<FormState>();
  TextEditingController offerSearchController = TextEditingController();
  TextEditingController offerTitleController = TextEditingController();

  @override
  void onInit() {
    fetchOffers();
    super.onInit();
  }

  clearTextFieldValue() {
    offerTitleController.clear();
  }

  getDate() {
    DateTime dateTimee = DateTime.now();
    var dateTime1 =
        DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').format(dateTimee).toString();

    dateTime = DateTime.parse(dateTime1).toIso8601String();
  }

//get offers
  fetchOffers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    isLoading.value = true;
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/api/v1/offer/offers"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log(res.statusCode.toString());
      log(res.body);
      isLoading.value = false;
      if (res.statusCode == 200) {
        offersResponseModel.value = offersResponseModelFromJson(res.body);
        offersSearchData.value = offersResponseModel;
        log(res.body);
      } else {
        errorToast(msg: "Offer fetching error");
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  Future<void> fetchMyOfferPost() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      int? id = prefs.getInt("id");
      isLoading.value = true;

      final res = await http.get(
        Uri.parse("$baseUrl/api/v1/user/$id/offers"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log(res.statusCode.toString());
      log("fetchMyOfferPost :: $baseUrl/api/v1/user/$id/offers");
      log(res.body);
      isLoading.value = false;
      if (res.statusCode == 200) {
        myOffersResponseModel.value = offersResponseModelFromJson(res.body);
        myOffersSearchData.value = myOffersResponseModel;
      } else {
        errorToast(msg: "My Offer fetching failed!");
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

// request offers
  uploadOffers(
      {File? citizenshipFront, bool? isFromServiceScreen = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    isLoading.value = true;
    paymentController.isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/user/$id/offers"),
        // Uri.parse(
        //     "$baseUrl/api/v1/extraPayment/${paymentController.paymentInitiateResponseModel.value.extraPaymentId}/user/$id/offers"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: jsonEncode(
          <String, dynamic>{
            "category": offerTitleController.text.trim().toString(),
          },
        ),
      );
      consolelog("uploadOffers :: $baseUrl/api/v1/user/$id/offers");
      consolelog(response.statusCode);
      consolelog(response.body);
      isLoading.value = false;
      if (response.statusCode == 201) {
        var result = offersUploadResponseModelFromJson(response.body);
        successToast(msg: "Offer uploaded succesfully");
        uploadImage(
          citizenshipFront: citizenshipFront,
          offerId: result.offerId.toString(),
          isFromServiceScreen: isFromServiceScreen,
        );
      } else {
        paymentController.isLoading.value = false;
        consolelog('error');
        errorToast(msg: "Error uploading offer");
      }
    } catch (e) {
      paymentController.isLoading.value = false;
      isLoading.value = false;
      errorToast(msg: e.toString());
    }
  }

  editOffers(
      {File? citizenshipFront,
      bool? isFromServiceScreen = false,
      String? offerId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    isLoading.value = true;
    paymentController.isLoading.value = true;
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/api/v1/offer/$offerId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: jsonEncode(
          <String, dynamic>{
            "title": offerTitleController.text.trim().toString(),
          },
        ),
      );
      consolelog("uploadOffers :: $baseUrl/api/v1/offer/$offerId");
      consolelog(response.statusCode);
      consolelog(response.body);
      isLoading.value = false;
      if (response.statusCode == 200) {
        var result = offersUploadResponseModelFromJson(response.body);
        successToast(msg: "Offer uploaded succesfully");
        uploadImage(
          citizenshipFront: citizenshipFront,
          offerId: result.offerId.toString(),
          isFromServiceScreen: isFromServiceScreen,
          fromEdit: true,
        );
      } else {
        paymentController.isLoading.value = false;
        consolelog('error');
        errorToast(msg: "Error uploading offer");
      }
    } catch (e) {
      paymentController.isLoading.value = false;
      isLoading.value = false;
      errorToast(msg: e.toString());
    }
  }

  Future uploadImage({
    File? citizenshipFront,
    String? offerId,
    bool? fromEdit = false,
    bool? isFromServiceScreen = false,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");

    var uri = Uri.parse('$baseUrl/api/allimg/upload/offer/$offerId');
    fromEdit ?? false ? isLoading.value = true : null;
    try {
      consolelog(citizenshipFront);
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $apptoken'
      });
      if (citizenshipFront != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "offerPicture",
            citizenshipFront.path,
            contentType: MediaType('image', 'jpg'),
          ),
        );
      }

      var data = await request.send();
      var response = await http.Response.fromStream(data);
      consolelog(uri);
      consolelog(response.statusCode);
      consolelog(response.body);
      paymentController.isLoading.value = false;
      fromEdit ?? false ? isLoading.value = false : null;
      if (response.statusCode == 200) {
        var responseJson = utf8.decode(response.bodyBytes);
        consolelog('image uploaded');
        consolelog(responseJson);
        fromEdit ?? false ? fetchMyOfferPost() : null;
        fromEdit ?? false
            ? Get.back()
            : Get.offAll(() => OfferScreen(
                  isFromServiceScreen: isFromServiceScreen,
                ));
        successToast(msg: "Offer Image upload succesfully");
      } else {
        errorToast(msg: "Offer Image upload failed");
      }
    } catch (e) {
      paymentController.isLoading.value = false;
      fromEdit ?? false ? isLoading.value = false : null;
      logger(e.toString(), loggerType: LoggerType.error);
      errorToast(msg: e.toString());
    }
  }

// // get extra services
//   getExtraServices() async {
//     isLoading.value = true;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? apptoken = prefs.getString("token");
//     int? id = prefs.getInt("id");
//     log(id.toString());
//     log('Get service  init $apptoken');
//     // log('get service  ${controller.token}');

//     try {
//       final response = await http.get(
//         Uri.parse("$baseUrl/api/v1/vacancy"),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization': "Bearer $apptoken"
//         },
//       );

//       print(response.statusCode);

//       if (response.statusCode == 200) {
//         isLoading.value = false;

//         final jsonList = json.decode(response.body);
//         extraServices.assignAll(
//           (jsonList as List)
//               .map(
//                 (offer) => OfferModel.fromJson(offer),
//               )
//               .toList(),
//         );

//         myOffers.assignAll(extraServices
//             .where((extraService) => extraService.serviceType == "offer")
//             .toList());

//         myVacancies.assignAll(extraServices
//             .where((extraService) => extraService.serviceType == "vacancy")
//             .toList());

//         mySecondHands.assignAll(extraServices
//             .where((extraService) => extraService.serviceType == "marketplace")
//             .toList());
//       } else {
//         isLoading.value = false;
//         print('error');
//       }
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
}
