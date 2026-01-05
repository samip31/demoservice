import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/views/serviceProviderScreen/service_main_screen.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import 'current_user_controller.dart';

class ServiceProviderController extends GetxController {
  var isLoading = false.obs;
  final storeController = Get.put(CurrentUserController());
  final controller = Get.put(AuthController());
  String baseUrl = BaseClient().baseUrl;

  Future serviceProviderEdit(String companyName, String firstName,
      String lastName, String latitude, String longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
      body: jsonEncode(<String, dynamic>{
        "email": controller.email,
        "password": controller.password,
        "mobileNumber": controller.mobileNumber,
        "companyName": companyName,
        "role": storeController.currentUserData.value.role,
        "citizenshipNum": storeController.currentUserData.value.citizenshipNum,
        "issuedDate": storeController.currentUserData.value.issuedDate,
        "fullname":
            "${storeController.currentUserData.value.firstName} ${storeController.currentUserData.value.lastName}",
        "latitude": storeController.currentUserData.value.latitude,
        "longitude": storeController.currentUserData.value.longitude,
        "workStatus": storeController.workStatus.value,
        "serviceProvided":
            storeController.currentUserData.value.serviceProvided,
        "firstName": firstName,
        "lastName": lastName
      }),
    );
    if (response.statusCode == 200) {
      log("serviceProviderEdit :: $baseUrl/api/users/$id");
      log(response.body);
      storeController.getCurrentUser();
      successToast(msg: "Successful");
      Get.to(() => const ServiceMainScreen());
    } else {
      errorToast(msg: "Please try again");
    }
  }
}
