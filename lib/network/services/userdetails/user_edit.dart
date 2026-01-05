import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/views/auth/login/login_screen.dart';
import 'package:smartsewa/views/user_screen/main_screen.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';

import '../../base_client.dart';
import '../authServices/auth_controller.dart';
import 'current_user_controller.dart';

class UserEditController extends GetxController {
  var isLoading = false.obs;
  final storeController = Get.put(CurrentUserController());
  final controller = Get.put(AuthController());
  String baseUrl = BaseClient().baseUrl;

  Future userProfileEdit(
      String firstName, String lastName, String latitude, String longitude,
      {bool? isFromServiceScreen = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    try {
      logger("data");
      consolelog(jsonEncode(<String, dynamic>{
        "email": controller.email,
        "password": storeController.currentUserData.value.password,
        "mobileNumber": storeController.currentUserData.value.mobileNumber,
        "companyName": storeController.currentUserData.value.companyName,
        "role": storeController.currentUserData.value.role,
        "citizenshipNum": storeController.currentUserData.value.citizenshipNum,
        "issuedDate": storeController.currentUserData.value.issuedDate,
        "fullname": "$firstName $lastName",
        "picture": storeController.currentUserData.value.picture,
        "latitude": latitude,
        "longitude": longitude,
        "serviceProvided":
            storeController.currentUserData.value.serviceProvided,
        "workStatus": storeController.workStatus.value,
        "firstName": firstName,
        "lastName": lastName
      }));
      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
        body: jsonEncode(<String, dynamic>{
          "email": storeController.currentUserData.value.email,
          "password": storeController.currentUserData.value.password,
          "mobileNumber": storeController.currentUserData.value.mobileNumber,
          "companyName": storeController.currentUserData.value.companyName,
          "role": storeController.currentUserData.value.role,
          "citizenshipNum":
              storeController.currentUserData.value.citizenshipNum,
          "issuedDate": storeController.currentUserData.value.issuedDate,
          "fullname": "$firstName $lastName",
          "picture": storeController.currentUserData.value.picture,
          "latitude": latitude,
          "longitude": longitude,
          "serviceProvided":
              storeController.currentUserData.value.serviceProvided,
          "workStatus": storeController.workStatus.value,
          "firstName": firstName,
          "lastName": lastName
        }),
      );
      Get.back();
      consolelog("userProfileEdit :: $baseUrl/api/users/$id");
      consolelog(response.statusCode);
      consolelog(response.body);
      if (response.statusCode == 200) {
        storeController.getCurrentUser();
        successToast(msg: "Profile updated successfully");
        isFromServiceScreen ?? false
            ? Get.back()
            : Get.offAll(() => const MainScreen());
      } else {
        errorToast(msg: "Error updating profile");
      }
    } catch (err) {
      Get.back();
      errorToast(msg: err.toString());
    }
  }

  Future userChangePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/$id/change-password'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
      body: jsonEncode(<String, dynamic>{
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword
      }),
    );
    log("This is change pw status: ${response.statusCode}");
    if (response.statusCode == 200) {
      successToast(msg: "Password changed successfully");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      log(preferences.getKeys().toList().toString());
      await preferences.remove('token');
      await preferences.remove('id');
      await preferences.remove('workStatus');
      await preferences.setBool('rememberMe', false);
      Get.offAll(() => const LoginScreen());
    } else {
      errorToast(msg: "Invalid old password");
    }
  }
}
