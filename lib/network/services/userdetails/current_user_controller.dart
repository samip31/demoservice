import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/base_client.dart';

import '../../models/currentuser_model.dart';
import '../authServices/auth_controller.dart';

class CurrentUserController extends GetxController {
  final controller = Get.put(AuthController());

  var currentUserData = CurrentUserResponseModel().obs;
  // String? email;
  // String? password;
  // String? mobileNumber;
  // String? companyName;
  // String? citizenshipNum;
  // String? issuedDate;
  // String? latitude;
  // String? longitude;
  // String? picture;
  // bool? role;
  // int? id;
  // bool? approval;
  // bool? onlineStatus;
  // String? fullName;
  // String? serviceProvided;
  // String? dateOfBirth;
  // String? jobTitle;
  // String? jobField;
  var workStatus = false.obs;
  // String? firstName;
  // String? lastName;
  var isLoading = false.obs;

  String baseUrl = BaseClient().baseUrl;
  // @override
  // void onInit() async {
  //   getCurrentUser();
  //   super.onInit();
  // }

  Future getCurrentUser() async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get user init $apptoken');
    // log('get user ${controller.token}');

    final response = await http.get(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
    );
    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      isLoading.value = false;
      var user = jsonDecode(response.body);
      log("getCurrentUser :: $baseUrl/api/users/$id");
      // log(response.body);

      currentUserData.value = currentUserResponseModelFromJson(response.body);
      // email = user['email'];
      // password = user['password'];
      // mobileNumber = user['mobileNumber'];
      // companyName = user['companyName'];

      // // role = user['role'];
      // citizenshipNum = user['citizenshipNum'];
      // issuedDate = user['issueDate'];
      // picture = user['picture'];
      // jobField = user['jobField'];
      // jobTitle = user['jobTitle'];

      // fullName = user['fullname'];
      // // imageUrlCitizenshipFront = user['imageUrlCitizenshipFront'];
      // latitude = user['latitude'];
      // longitude = user["longitude"];
      workStatus.value = user['workStatus'];
      // serviceProvided = user["serviceProvided"];
      // approval = user['approval'];
      // onlineStatus = user["onlineStatus"];
      // firstName = user['firstName'];
      // lastName = user['lastName'];

    } else {
      isLoading.value = false;
    }
  }
}
