import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../base_client.dart';
import '../authServices/auth_controller.dart';

class ContactsController extends GetxController {
  final controller = Get.put(AuthController());
  int? variableId;
  String? promoCode;
  String? contactUs;
  String? email;
  String? address;
  String? feedbackEmail;
  var isLoading = false.obs;
  String baseUrl = BaseClient().baseUrl;

  @override
  void onInit() {
    fetchContacts();
    super.onInit();
  }

  fetchContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get contacts init $apptoken');
    // log('get contact ${controller.token}');
    isLoading.value = true;
    final res = await http.get(
      Uri.parse('$baseUrl/api/variableEntity/1'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            "Bearer $apptoken"
      },
    );
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      isLoading.value = false;
      var user = jsonDecode(res.body);
      variableId = user['variableId'];
      promoCode = user['promoCode'];
      contactUs = user['contactUs'];
      address = user['address'];
      email = user['email'];
      feedbackEmail = user['feedbackEmail'];
      print(res.body);
    } else {
      isLoading.value = false;
      print('error');
    }
  }
}
