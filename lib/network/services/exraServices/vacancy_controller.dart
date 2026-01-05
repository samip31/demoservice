import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/models/inidividual_vacancy_model.dart';
import 'package:smartsewa/network/models/vacancy_model.dart';
import 'package:http/http.dart' as http;
import 'package:smartsewa/network/models/vacancy_upload_response_model.dart';
import 'package:smartsewa/network/services/exraServices/payment_controller.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/vacancy.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import '../../../core/development/console.dart';
import '../../../core/enum.dart';

class VacancyController extends GetxController {
  final paymentController = Get.put(PaymentController());

  final vacancyResponseModel = <VacancyResponseModel>[].obs;
  final vacancySearchData = <VacancyResponseModel>[].obs;
  final myVacancyResponseModel = <VacancyResponseModel>[].obs;
  final myVacancySearchData = <VacancyResponseModel>[].obs;
  final individualVacancyResponseModel = IndividualVacancyResponseModel().obs;
  var isLoading = false.obs;
  final baseUrl = BaseClient().baseUrl;
  String? dateTime;

  GlobalKey<FormState> vacancyFormState = GlobalKey<FormState>();
  TextEditingController vacancyPositionController = TextEditingController();
  TextEditingController vacancyTitleController = TextEditingController();
  TextEditingController vacancyOfficeNameController = TextEditingController();
  TextEditingController vacancyQuantityController = TextEditingController();
  TextEditingController vacancyQualificationController =
      TextEditingController();
  TextEditingController vacancyApplyCvEmailController = TextEditingController();
  TextEditingController vacancuyAddressController = TextEditingController();
  TextEditingController vacancyContactController = TextEditingController();
  TextEditingController vacancySearchController = TextEditingController();

  @override
  void onInit() {
    fetchVacancy();
    super.onInit();
  }

  vacancyResetController() {
    vacancuyAddressController.clear();
    vacancyApplyCvEmailController.clear();
    vacancyContactController.clear();
    vacancyOfficeNameController.clear();
    vacancyPositionController.clear();
    vacancyQualificationController.clear();
    vacancyQuantityController.clear();
    vacancyTitleController.clear();
  }

  getDate() {
    DateTime dateTimee = DateTime.now();
    String dateTime1 =
        DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').format(dateTimee).toString();

    dateTime = DateTime.parse(dateTime1).toIso8601String();
  }

  fetchVacancy() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      int? id = prefs.getInt("id");
      isLoading.value = true;

      final res = await http.get(
        Uri.parse("$baseUrl/api/v1/vacancy"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log(res.statusCode.toString());
      log(res.body);
      isLoading.value = false;
      if (res.statusCode == 200) {
        // final List<dynamic> data = json.decode(res.body);
        // vacancyResponseModel.value =
        //     data.map((item) => VacancyResponseModel.fromJson(item)).toList();
        vacancyResponseModel.value = vacancyResponseModelFromJson(res.body);
        vacancySearchData.value = vacancyResponseModel;
      } else {
        isLoading.value = false;
        errorToast(msg: "Vacancy fetching failed!");
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  fetchMyVacancyPost() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      int? id = prefs.getInt("id");
      isLoading.value = true;

      final res = await http.get(
        Uri.parse("$baseUrl/api/v1/user/$id/vacancies"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log(res.statusCode.toString());
      log(res.body);
      isLoading.value = false;
      if (res.statusCode == 200) {
        // final List<dynamic> data = json.decode(res.body);
        // vacancyResponseModel.value =
        //     data.map((item) => VacancyResponseModel.fromJson(item)).toList();
        myVacancyResponseModel.value = vacancyResponseModelFromJson(res.body);
        myVacancySearchData.value = myVacancyResponseModel;
      } else {
        isLoading.value = false;
        errorToast(msg: "My Vacancy fetching failed!");
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  fetchInidividualVacancy({int? vacancyId}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      isLoading.value = true;

      final res = await http.get(
        Uri.parse("$baseUrl/api/v1/vacancy/$vacancyId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log(res.statusCode.toString());
      log(res.body);
      isLoading.value = false;
      if (res.statusCode == 200) {
        individualVacancyResponseModel.value =
            individualVacancyResponseModelFromJson(res.body);
      } else {
        isLoading.value = false;
        errorToast(msg: "Vacancy fetching failed!");
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  // request vacancies
  uploadVacancies({File? file, bool? isFromServiceScreen = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    getDate();
    isLoading.value = true;
    paymentController.isLoading.value = true;
    try {
      var data = file == null
          ? jsonEncode(<String, dynamic>{
              "serviceType": "vacancy",
              "title": vacancyTitleController.text.trim().toString(),
              "quantity": vacancyQuantityController.text.trim().toString(),
              "contact": vacancyContactController.text.trim().toString(),
              "address": vacancuyAddressController.text.trim().toString(),
              "position": vacancyPositionController.text.trim().toString(),
              "officeName": vacancyOfficeNameController.text.trim().toString(),
              "applyCvEmail":
                  vacancyApplyCvEmailController.text.trim().toString(),
              "qualification":
                  vacancyQualificationController.text.trim().toString(),
              "picture": selectedVacancyTemplate.value?.split("/")[6],
            })
          : jsonEncode(<String, dynamic>{
              "serviceType": "vacancy",
              "title": vacancyTitleController.text.trim().toString(),
              "quantity": vacancyQuantityController.text.trim().toString(),
              "contact": vacancyContactController.text.trim().toString(),
              "address": vacancuyAddressController.text.trim().toString(),
              "position": vacancyPositionController.text.trim().toString(),
              "officeName": vacancyOfficeNameController.text.trim().toString(),
              "applyCvEmail":
                  vacancyApplyCvEmailController.text.trim().toString(),
              "qualification":
                  vacancyQualificationController.text.trim().toString(),
            });
      consolelog(data);
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/user/$id/vacancy"),
        // Uri.parse(
        //     "$baseUrl/api/v1/extraPayment/${paymentController.paymentInitiateResponseModel.value.extraPaymentId}/user/$id/vacancy"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: data,
      );
      consolelog(response.statusCode);
      consolelog("url : $baseUrl/api/v1/user/$id/vacancy");
      consolelog(response.body);
      isLoading.value = false;
      if (response.statusCode == 201) {
        var result = vacancyUploadResponseModelFromJson(response.body);
        successToast(msg: "Vacancy uploaded succesfully");
        if (file != null) {
          consolelog(file);
          uploadImage(
            file: file,
            vacancyId: result.vacancyId.toString(),
            isFromServiceScreen: isFromServiceScreen,
          );
        } else {
          Get.back();
          Get.offAll(() => Vacancy(
                isFromServiceScreen: isFromServiceScreen,
              ));
        }
      } else {
        // Get.back();
        paymentController.isLoading.value = false;
        errorToast(msg: "Vacancy upload failed");
      }
    } catch (e) {
      // Get.back();
      paymentController.isLoading.value = false;
      isLoading.value = false;
      consolelog(e.toString());
      errorToast(msg: e.toString());
    }
  }

  editVacancies(
      {File? file,
      bool? isFromServiceScreen = false,
      String? vacancyId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    getDate();
    isLoading.value = true;
    try {
      var data = file == null
          ? jsonEncode(<String, dynamic>{
              "serviceType": "vacancy",
              "title": vacancyTitleController.text.trim().toString(),
              "quantity": vacancyQuantityController.text.trim().toString(),
              "contact": vacancyContactController.text.trim().toString(),
              "address": vacancuyAddressController.text.trim().toString(),
              "position": vacancyPositionController.text.trim().toString(),
              "officeName": vacancyOfficeNameController.text.trim().toString(),
              "applyCvEmail":
                  vacancyApplyCvEmailController.text.trim().toString(),
              "qualification":
                  vacancyQualificationController.text.trim().toString(),
              "picture": selectedVacancyTemplate.value?.split("/")[6],
            })
          : jsonEncode(<String, dynamic>{
              "serviceType": "vacancy",
              "title": vacancyTitleController.text.trim().toString(),
              "quantity": vacancyQuantityController.text.trim().toString(),
              "contact": vacancyContactController.text.trim().toString(),
              "address": vacancuyAddressController.text.trim().toString(),
              "position": vacancyPositionController.text.trim().toString(),
              "officeName": vacancyOfficeNameController.text.trim().toString(),
              "applyCvEmail":
                  vacancyApplyCvEmailController.text.trim().toString(),
              "qualification":
                  vacancyQualificationController.text.trim().toString(),
            });
      consolelog(data);
      final response = await http.put(
        Uri.parse("$baseUrl/api/v1/vacancy/$vacancyId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: data,
      );
      consolelog(response.statusCode);
      consolelog("url :: $baseUrl/api/v1/vacancy/$vacancyId");
      consolelog(response.body);
      isLoading.value = false;
      if (response.statusCode == 200) {
        // var result = vacancyUploadResponseModelFromJson(response.body);
        successToast(msg: "Vacancy edited succesfully");

        Get.back();
        fetchMyVacancyPost();
      } else {
        errorToast(msg: "Vacancy edit failed");
      }
    } catch (e) {
      isLoading.value = false;
      consolelog(e.toString());
      errorToast(msg: e.toString());
    }
  }

  Future uploadImage(
      {File? file,
      String? vacancyId,
      bool? isFromServiceScreen = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");

    var uri = Uri.parse('$baseUrl/api/allimg/upload/vacancy/$vacancyId');
    try {
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $apptoken'
      });
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "vacancyPicture",
            file.path,
            contentType: MediaType('image', 'jpg'),
          ),
        );
      }

      var data = await request.send();
      var response = await http.Response.fromStream(data);
      consolelog(uri);
      consolelog(response.body);
      // Get.back();
      paymentController.isLoading.value = false;
      if (response.statusCode == 200) {
        var responseJson = utf8.decode(response.bodyBytes);
        consolelog(responseJson);
        successToast(msg: "Vacancy Image upload succesfully");
        Get.offAll(() => Vacancy(
              isFromServiceScreen: isFromServiceScreen,
            ));
      } else {
        errorToast(msg: "Vacancy Image upload failed");
      }
    } catch (e) {
      // Get.back();
      paymentController.isLoading.value = false;
      logger(e.toString(), loggerType: LoggerType.error);
      errorToast(msg: e.toString());
    }
  }

  updateAvailableStatusVacancy({String? vacancyId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    getDate();
    // isLoading.value = true;
    try {
      final response = await http.put(
        Uri.parse(
          "$baseUrl/api/v1/$vacancyId/availableStatus",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      isLoading.value = false;
      consolelog(
          "updateAvailableStatusVacancy :: $baseUrl/api/v1/$vacancyId/availableStatus");
      consolelog(response.statusCode);
      consolelog(response.body);
      isLoading.value = false;
      Get.back();
      if (response.statusCode == 200) {
        // var result = marketPlaceUploadResponseModelFromJson(response.body);
        fetchMyVacancyPost();
        successToast(msg: "Available status updated successful");
      } else {
        errorToast(msg: "Vacancy upload status failed");
      }
    } catch (e) {
      Get.back();
      isLoading.value = false;
      errorToast(msg: e.toString());
    }
  }
}
