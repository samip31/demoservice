import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/enum.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/models/common_response_model.dart';
import 'package:smartsewa/views/user_screen/main_screen.dart';
import 'package:smartsewa/views/widgets/Welcome%20Screen/splashscreen.dart';
import 'package:smartsewa/views/widgets/Welcome%20Screen/welcome_screen.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import '../../../views/auth/login/login_screen.dart';

import '../userdetails/current_user_controller.dart';

class AuthController extends GetxController {
  String? email;
  String? password;
  String? mobileNumber;
  String? companyName;
  String? citizenshipNum;
  String? issuedDate;
  String? fullName;
  String? latitude;
  String? longitude;

  var workStatus = false;
  String? serviceProvided;

  bool? role;
  String? firstName;
  String? lastName;
  String? apptoken;
  var isLoading = false.obs;
  String baseUrl = BaseClient().baseUrl;
  var isLogged = false.obs;
  final pickedJobFieldName = ''.obs;

  TextEditingController otpController = TextEditingController();

  ///***Api hit for sms ***///
  // String apiKey = 'v2_aDW1PIhMnzH79EeoyWAn6tH3gFt.K7aZ'; //token generated
  String apiKey = 'v2_2etEFePqLir0oVz35BZmRNHHFE7.stXv';

  ///******Api For Login *****///
  Future login(TextEditingController emailController,
      TextEditingController passwordController) async {
    try {
      final userController = Get.put(CurrentUserController());
      isLoading.value = true;
      consolelog(jsonEncode(
        <String, dynamic>{
          "username": emailController.text,
          "password": passwordController.text,
        },
      ));
      consolelog("login :: $baseUrl/api/v1/auth/login");
      final res = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          <String, dynamic>{
            "username": emailController.text,
            "password": passwordController.text,
          },
        ),
      );
      consolelog("login :: $baseUrl/api/v1/auth/login");
      consolelog(res.statusCode);
      consolelog(res.body);
      isLoading.value = false;
      if (res.statusCode == 200) {
        // emailController.clear;
        // passwordController.clear;
        var user = jsonDecode(res.body);
        log("login :: $baseUrl/api/v1/auth/login");
        log(res.body);
        // token = user['token'];
        email = user['user']['email'];
        password = user['user']['password'];
        mobileNumber = user['user']['mobileNumber'];
        companyName = user['user']['companyName'];
        role = user['user']['role'];
        citizenshipNum = user['user']['citizenshipNum'];
        issuedDate = user['user']['issueDate'];
        fullName = user['user']['fullname'];
        latitude = user['user']['latitude'];
        longitude = user['user']['longitude'];
        workStatus = user['user']['workStatus'];
        serviceProvided = user['user']["serviceProvided"];
        // id = user['user']['id'];
        firstName = user['user']['firstName'];
        lastName = user['user']['lastName'];
        userController.getCurrentUser();
        int tid = user['user']['id'];

        final apptoken = user['token'];
        log("id is $tid");
        var prefs = await SharedPreferences.getInstance();
        logger("workStatus :: $workStatus", loggerType: LoggerType.success);
        await prefs.setBool(SplashScreenState.keylogin, true);
        await prefs.setBool("workStatus", workStatus);
        await prefs.setString('token', apptoken);
        await prefs.setInt("id", tid);
        await prefs.setBool("rememberMe", true);
        selectedAutoLogin.value = prefs.getBool("rememberMe");

        successToast(msg: "Login successfully");
        if (apptoken != null && workStatus == true) {
          Get.offAll(() => const WelcomeScreen());
        } else {
          Get.offAll(() => const MainScreen());
        }
        emailController.clear();
        passwordController.clear();

        // log('ID: $id');

        // Get.offAll(() => const MainScreen());
        //Get.offAll(() => MyScreen());
      } else {
        errorToast(msg: "Invalid Username or Password");
      }
    } catch (err) {
      isLoading.value = false;
      consolelog(err);
      if (err.toString().contains('SocketException')) {
        return errorToast(msg: 'no internet');
      } else {
        errorToast(msg: err.toString());
      }
    }
  }

  Future<void> uploadProfile(File? profilePicture,
      {bool? isFromServiceScreen = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");
    final userController = Get.put(CurrentUserController());

    log(tid.toString());
    // log(id.toString());
    log('Get images init $apptoken');
    // log('get images $token');
    try {
      var profilestream = http.ByteStream(profilePicture!.openRead());

      // log('frontstream: $frontstream');
      // // uploading file as a stream
      // frontstream.cast();
      // backstream.cast();
      profilestream.cast();

      // getting length of file
      // var frontlength = citizenshipFront.lengthSync();
      // var backlength = citizenshipBack.lengthSync();
      var profilelength = profilePicture.lengthSync();
      log('profilelength: $profilelength');

      // log('frontlength: $frontlength');

      // post file
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/api/allimg/upload/profile/$tid'));
// http://13.232.92.169:9000/api/allimg/upload/profile/2007
      // adding header
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        // 'Content-Type': 'charset=UTF-8',
        'Authorization': 'Bearer $apptoken'
      });

      // adding each images
      // request.files.add(http.MultipartFile.fromBytes(
      //     'citizenshipFront', citizenshipFront.readAsBytesSync(),
      //     filename: "citizenshipFront"));
      // request.files.add(http.MultipartFile.fromBytes(
      //     'profilePicture', profilePicture.readAsBytesSync(),
      //     filename: "profilePicture"));
      request.files.add(http.MultipartFile.fromBytes(
          'profilePicture', profilePicture.readAsBytesSync(),
          filename: profilePicture.path.split("/").last));
      // request.files.add(http.MultipartFile.fromBytes(
      //     'profilePicture', profilePicture.readAsBytesSync(),
      //     filename: "profilePicture"));

      var response = await request.send();

      log('stream: ${response.stream.toString()}');

      log('status code: ${response.statusCode}');
      Get.back();
      if (response.statusCode == 200) {
        var resdata = await response.stream.toBytes();
        var result = String.fromCharCodes(resdata);
        log("uploadProfile :: $baseUrl/api/allimg/upload/profile/$tid");
        log(result);
        var data = jsonDecode(result);
        log('image uploaded');
        log('emaillll:${data["email"]}');
        userController.getCurrentUser();
        Get.offAll(() => const MainScreen());
        successToast(msg: 'Image Uploaded successfully!');
      } else {
        log('failed');
        errorToast(msg: 'Image Upload failed!');
      }
    } catch (e) {
      Get.back();
      errorToast(msg: e.toString());
      throw Exception(e.toString());
    }
  }

//  var resJson;

//   onUploadImage( File? profilepicture) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? apptoken = prefs.getString("token");
//     int? tid = prefs.getInt("id");
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse("$baseUrl/api/allimg/upload/profile/$tid}"),
//     );
//     Map<String, String> headers = {"Content-type": "multipart/form-data"};
//     request.files.add(
//       http.MultipartFile(
//         'profilePicture',
//         profilepicture!.readAsBytes().asStream(),
//         profilepicture.lengthSync(),
//         filename: profilepicture.path.split('/').last,
//       ),
//     );
//     request.headers.addAll(headers);
//     log("request: " + request.toString());
//     var res = await request.send();
//     http.Response response = await http.Response.fromStream(res);
//     resJson = jsonDecode(response.body);
//   }

  Future registerUser(String firstname, String lastname, String mobile,
      String email, String password, String latitude, String longitude) async {
    try {
      isLoading.value = true;
      var data = email != ""
          ? jsonEncode(
              <String, dynamic>{
                "email": email,
                "password": password,
                "mobileNumber": mobile,
                "fullname": "$firstname $lastname ",
                "latitude": latitude,
                "longitude": longitude,
                "firstName": firstname,
                "lastName": lastname,
              },
            )
          : jsonEncode(
              <String, dynamic>{
                "password": password,
                "mobileNumber": mobile,
                "fullname": "$firstname $lastname ",
                "latitude": latitude,
                "longitude": longitude,
                "firstName": firstname,
                "lastName": lastname,
              },
            );

      // consolelog(data);
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: data,
      );

      consolelog("registerUser :: $baseUrl/api/v1/auth/register");
      consolelog(response.statusCode);
      // consolelog(response.body);
      Get.back();
      isLoading(false);
      if (response.statusCode == 201) {
        successToast(msg: "User Registered Successfully");
        Get.offAll(
          () => const LoginScreen(),
        );
      } else {
        Get.defaultDialog(
            buttonColor: Colors.red,
            titlePadding: const EdgeInsets.only(top: 20),
            title: 'Error',
            titleStyle: const TextStyle(color: Colors.black, fontSize: 20),
            textConfirm: 'Ok',
            onConfirm: () {
              Get.back();
            },
            content: const Text(
              'Something went wrong or phone number already exists',
              textAlign: TextAlign.center,
            ));
      }
    } catch (err) {
      Get.back();
      isLoading(false);
      if (err.toString().contains('SocketException')) {
        return errorToast(msg: 'no internet');
      } else {
        errorToast(msg: err.toString());
      }
    }
  }

  Future forgotPassword({
    // String? oldPassword,
    String? newPassword,
    String? confirmPassword,
    String? mobileNumber,
  }) async {
    try {
      isLoading.value = true;
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/$mobileNumber/forget-password'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        }),
      );
      log("forgotPassword :: $baseUrl/api/v1/auth/$mobileNumber/forget-password");
      log(response.body);
      log(response.statusCode.toString());
      CommonResponseModel? result = CommonResponseModel();
      result = commonResponseModelFromJson(response.body);
      if (response.statusCode == 200) {
        successToast(msg: result.message);
        Get.offAll(
          () => const LoginScreen(),
        );
      } else {
        log(result.message ?? "");
        errorToast(msg: result.message.toString());
        // Get.defaultDialog(
        //     buttonColor: Colors.red,
        //     titlePadding: const EdgeInsets.only(top: 20),
        //     title: 'Invalid password',
        //     titleStyle: const TextStyle(color: Colors.black, fontSize: 20),
        //     textConfirm: 'Ok',
        //     onConfirm: () {
        //       Get.back();
        //     },
        //     content: const Text(
        //       'Please enter a valid password',
        //       textAlign: TextAlign.center,
        //     ));
      }
    } catch (err) {
      isLoading(false);
      log(err.toString());
      errorToast(msg: err.toString());
    } finally {
      log("sda");
      isLoading(false);
    }
  }

  Future checkNumberAndEmailRegister({
    String? email,
    String? mobileNumber,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/users/emailAndMobile?email=$email&mobileNumber=$mobileNumber'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      log("checkNumberAndEmailRegister :: $baseUrl/api/users/emailAndMobile?email=$email&mobileNumber=$mobileNumber");
      log('body: ${response.body}');
      log(response.statusCode.toString());
      CommonResponseModel? result = CommonResponseModel();
      if (response.statusCode == 200) {
        return true;
      } else {
        log(result.message ?? "");
        errorToast(msg: result.message.toString());
      }
      return false;
    } catch (err) {
      isLoading(false);
      log(err.toString());
      if (err.toString().contains('SocketException')) {
         errorToast(msg: 'no internet');
         print('no internet');
      } else {
        errorToast(msg: err.toString());
      }
      return false;
    }
  }

  // service ,provided by sms provider
  Future<void> sendOTP(
      {String? phoneNumber, int? randomNumber, String? message}) async {
    var response = await http.post(
      Uri.parse("https://api.sparrowsms.com/v2/sms/"),
      body: {
        'token': apiKey,
        'to': phoneNumber,
        'from': "TheAlert",
        'text': """
From Smart Sewa,
$message : $randomNumber
""",
      },
    );
    logger(response.body, loggerType: LoggerType.success);
    if (response.statusCode == 200) {
      // Get.to(() => RegisterOtp(
      //       number: _randomNumber,
      //       email: _emailController.text,
      //       password: _passwordController.text,
      //       firstName: _firstnameController.text,
      //       lastName: _lastnameController.text,
      //       phone: _phoneController.text,
      //     ));
    }
  }
}
