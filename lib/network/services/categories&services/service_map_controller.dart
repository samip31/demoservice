import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../base_client.dart';
import '../../models/service_map_model.dart';
import 'package:http/http.dart' as http;

import '../authServices/auth_controller.dart';

class MyMapController extends GetxController {
  var users = <ServiceMapModel>[].obs;
  var isMapLoading = true.obs;
  // putting the authController so that we can access the pickedJobFieldName to hit the api
  // to fetch the particular service providers that provide those services
  final authController = Get.put(AuthController());

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  final controller = Get.put(AuthController());

  String baseUrl = BaseClient().baseUrl;

  fetchUsers() async {
    isMapLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get service map init $apptoken');
    // log('get service map ${controller.token}');
    try {
      log("USER FETCHING PARTICULAR USERS LOCATIONS: ${authController.pickedJobFieldName}");
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/users/jobField?jobField=${authController.pickedJobFieldName}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log("USER FETCHING PARTICULAR USERS LOCATIONS: ${response.body}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<ServiceMapModel> serviceProviders =
            data.map((item) => ServiceMapModel.fromJson(item)).toList();
        users.value = serviceProviders;
      } else {
        throw Exception('Failed to fetch users');
      }
    } finally {
      isMapLoading.value = false;
    }
  }
}
