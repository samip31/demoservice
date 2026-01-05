import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/services/exraServices/payment_controller.dart';
import 'package:smartsewa/network/services/userdetails/current_user_controller.dart';
import 'package:http_parser/http_parser.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';

import '../../../views/user_screen/main_screen.dart';

class RegisterServiceController extends GetxController {
  String baseUrl = BaseClient().baseUrl;
  final paymentController = Get.put(PaymentController());
  final profileController = Get.put(CurrentUserController());
  final isLoading = false.obs;

  @override
  void onInit() {
    CurrentUserController().getCurrentUser();
    super.onInit();
  }

  // Future uploadImage(File? citizenshipFront, File? citizenshipBack,
  //     File? associationImg, File? academicImg) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? apptoken = prefs.getString("token");
  //   int? tid = prefs.getInt("id");

  //   try {
  //     var frontstream = http.ByteStream(citizenshipFront!.openRead());
  //     var backstream = http.ByteStream(citizenshipBack!.openRead());
  //     var associationstream = http.ByteStream(associationImg!.openRead());
  //     var academicstream = http.ByteStream(academicImg!.openRead());

  //     consolelog('frontstream: $frontstream');
  //     // uploading file as a stream
  //     frontstream.cast();
  //     backstream.cast();
  //     associationstream.cast();
  //     academicstream.cast();

  //     // getting length of file
  //     var frontlength = citizenshipFront.lengthSync();
  //     var backlength = citizenshipBack.lengthSync();
  //     var associationlength = associationImg.lengthSync();
  //     var academiclength = academicImg.lengthSync();

  //     consolelog('frontlength: $frontlength');

  //     // post file
  //     var request = http.MultipartRequest(
  //       'POST',
  //       //  Uri.parse('$baseUrl/api/allimg/upload/img/$id'));
  //       Uri.parse('$baseUrl/api/allimg/user/otherimg/$tid'),
  //     );

  //     // adding header
  //     request.headers.addAll({
  //       'Content-Type': 'multipart/form-data',
  //       'Authorization': 'Bearer $apptoken'
  //     });

  //     // adding each images
  //     request.files.add(http.MultipartFile.fromBytes(
  //         'citizenshipFront', citizenshipFront.readAsBytesSync(),
  //         filename: "citizenshipFront"));
  //     request.files.add(http.MultipartFile.fromBytes(
  //         'citizenshipBack', citizenshipBack.readAsBytesSync(),
  //         filename: "citizenshipBack"));
  //     request.files.add(http.MultipartFile.fromBytes(
  //         'associationImg', associationImg.readAsBytesSync(),
  //         filename: associationImg.path.split("/").last));
  //     request.files.add(http.MultipartFile.fromBytes(
  //         'academicPicture', academicImg.readAsBytesSync(),
  //         filename: academicImg.path.split("/").last));

  //     var response = await request.send();

  //     print('stream: ${response.stream.toString()}');

  //     print('status code: ${response.statusCode}');
  //     if (response.statusCode == 200) {
  //       var resdata = await response.stream.toBytes();
  //       var result = String.fromCharCodes(resdata);
  //       var data = jsonDecode(result);
  //       // Get.to(() => const PaymentScreen());

  //       print('image uploaded');
  //       print('emaillll:${data["email"]}');
  //     } else {
  //       print('failed');
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  Future uploadImage(File? citizenshipFront, File? citizenshipBack,
      File? associationImg, File? academicImg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");
    isLoading.value = true;
    try {
      // post file
      var request = http.MultipartRequest(
        'POST',
        //  Uri.parse('$baseUrl/api/allimg/upload/img/$id'));
        Uri.parse('$baseUrl/api/allimg/user/otherimg/$tid'),
      );

      // adding header
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $apptoken'
      });
      if (citizenshipFront != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "citizenshipFront", citizenshipFront.path,
            contentType: MediaType('image', 'jpg')));
      }
      if (citizenshipBack != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "citizenshipBack", citizenshipBack.path,
            contentType: MediaType('image', 'jpg')));
      }
      if (associationImg != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "associationImg", associationImg.path,
            contentType: MediaType('image', 'jpg')));
      }
      if (academicImg != null) {
        request.files.add(await http.MultipartFile.fromPath(
            "academicPicture", academicImg.path,
            contentType: MediaType('image', 'jpg')));
      }

      // adding each images
      // request.files.add(http.MultipartFile.fromBytes(
      //     'citizenshipFront', citizenshipFront.readAsBytesSync(),
      //     filename: "citizenshipFront"));
      // request.files.add(http.MultipartFile.fromBytes(
      //     'citizenshipBack', citizenshipBack.readAsBytesSync(),
      //     filename: "citizenshipBack"));
      // request.files.add(http.MultipartFile.fromBytes(
      //     'associationImg', associationImg.readAsBytesSync(),
      //     filename: associationImg.path.split("/").last));
      // request.files.add(http.MultipartFile.fromBytes(
      //     'academicPicture', academicImg.readAsBytesSync(),
      //     filename: academicImg.path.split("/").last));

      var data = await request.send();
      var response = await http.Response.fromStream(data);

      consolelog('response body: ${response.body}');

      consolelog('status code: ${response.statusCode}');
      isLoading.value = false;
      consolelog(
          "Images :: $citizenshipFront $citizenshipBack $academicImg $associationImg");
      Get.back(); // without payment
      if (response.statusCode == 200) {
        Get.defaultDialog(
          barrierDismissible: false,
          title: 'Form Accepted',
          confirm: ElevatedButton(
            child: const Text(
              "OK",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              profileController.getCurrentUser();
              log("USER BECOCMING A SERCVICE  PROVIDER");
              Get.back();
              Get.back();
            },
          ),
          titleStyle: const TextStyle(fontSize: 22, color: Colors.red),
          content: Container(
            padding: const EdgeInsets.all(18),
            child: const Text(
              "Thank you for your submission .Please wait for us to confirm your request",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        );
      } else {
        errorToast(msg: "Images not uploaded");
      }
    } catch (e) {
      Get.back(); // without payment
      isLoading.value = false;
      errorToast(msg: e.toString());
    }
  }

  ///*** Service Provider Approval Form Api***///
  void registerService({
    required String email,
    required String password,
    required String mobileNumber,
    required String jobTitle,
    required String jobField,
    required String citizenNumber,
    required String issuedDistrict,
    required String date,
    required String dateOfBirth,
    required String gender,
    required String latitude,
    required String longitude,
    // bool onlineStatus,
    File? citizenshipFront,
    File? citizenshipBack,
    File? academicImg,
    File? associationImg,
  }) async {
    final CurrentUserController currentUserController =
        Get.put(CurrentUserController());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");
    isLoading.value = true;
    try {
      var data = email == "null"
          ? jsonEncode({
              "password": password,
              "mobileNumber": mobileNumber,
              "companyName": "our company",
              "citizenshipNum": citizenNumber,
              "issuedDate": date,
              "fullname":
                  "${currentUserController.currentUserData.value.firstName} ${currentUserController.currentUserData.value.lastName} ",
              "picture": currentUserController.currentUserData.value.picture,
              "latitude": latitude,
              "longitude": longitude,
              "serviceProvided": jobTitle,
              "workStatus": currentUserController.workStatus.value,
              "approval": true,
              "onlineStatus":
                  currentUserController.currentUserData.value.onlineStatus,
              "dateOfBirth": dateOfBirth,
              "cv": "no cv",
              "firstName":
                  currentUserController.currentUserData.value.firstName,
              "lastName": currentUserController.currentUserData.value.lastName,
              "jobTitle": jobTitle,
              "jobField": jobField,
              "issusedDistrict": issuedDistrict,
              "gender": gender,
            })
          : jsonEncode({
              "email": email,
              "password": password,
              "mobileNumber": mobileNumber,
              "companyName": "our company",
              "citizenshipNum": citizenNumber,
              "issuedDate": date,
              "fullname":
                  "${currentUserController.currentUserData.value.firstName} ${currentUserController.currentUserData.value.lastName} ",
              "picture": currentUserController.currentUserData.value.picture,
              "latitude": latitude,
              "longitude": longitude,
              "serviceProvided": jobTitle,
              "workStatus": currentUserController.workStatus.value,
              "approval": true,
              "onlineStatus":
                  currentUserController.currentUserData.value.onlineStatus,
              "dateOfBirth": dateOfBirth,
              "cv": "no cv",
              "firstName":
                  currentUserController.currentUserData.value.firstName,
              "lastName": currentUserController.currentUserData.value.lastName,
              "jobTitle": jobTitle,
              "jobField": jobField,
              "issusedDistrict": issuedDistrict,
              "gender": gender,
            });
      consolelog(data);
      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$tid'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: data,
      );
      log('url :: $baseUrl/api/users/$tid');
      // log("apptoken :: $apptoken");
      log('code: ${response.statusCode}');
      log('code: ${response.body}');
      isLoading.value = false;
      // Get.back();
      if (response.statusCode == 200) {
        successToast(msg: "Service Provider data succesfully registered");
        uploadImage(
            citizenshipFront, citizenshipBack, associationImg, academicImg);
        CurrentUserController().getCurrentUser();
      } else {
        Get.back(); // without payment
        isLoading.value = false;
        errorToast(msg: "Please try again");
      }
    } catch (e) {
      Get.back(); // without payment
      print('this ::::::::::::::: $e');
      errorToast(msg: e.toString());
    }
  }

  void renewService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");
    isLoading.value = true;

    try {
      final response = await http.put(
        Uri.parse(
            '$baseUrl/api/v1/${paymentController.paymentServiceResponseModel.value.paymentId}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log('url :: $baseUrl/api/v1/${paymentController.paymentServiceResponseModel.value.paymentId}');
      log('code: ${response.statusCode}');
      isLoading.value = false;

      if (response.statusCode == 200) {
        successToast(msg: "Service Provider data succesfully renewed");
        CurrentUserController().getCurrentUser();
        Get.back();
      } else {
        isLoading.value = false;
        errorToast(msg: "Service Provider renewed error");
      }
    } catch (e) {
      errorToast(msg: e.toString());
    }
  }
}
