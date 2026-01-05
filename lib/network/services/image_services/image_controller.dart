import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../base_client.dart';
import 'package:http/http.dart' as http;

import '../authServices/auth_controller.dart';

class ImageController extends GetxController {
  final controller = Get.put(AuthController());

  String baseUrl = BaseClient().baseUrl;

  @override
  void onInit() {
    // fetchImages(controller.);
    super.onInit();
  }

  var res;
  fetchImages(imageName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get contacts init $apptoken');
    // log('get contact ${controller.token}');
    final res = await http.get(
      Uri.parse('$baseUrl/api/allimg/image/$imageName'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
    );
    log(res.statusCode.toString());
    if (res.statusCode == 200) {
      // log(res.body);
      // ImageController().res = res.body;
    } else {
      print('error');
    }
  }
}

  // fetchContacts() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? apptoken = prefs.getString("token");
  //   int? id = prefs.getInt("id");
  //   log(id.toString());
  //   log('Get contacts init $apptoken');
  //   log('get contact ${controller.token}');
  //   isLoading.value = true;
  //   final res = await http.get(
  //     Uri.parse('$baseUrl/api/variableEntity/1'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization':
  //           "Bearer ${(apptoken == null) ? controller.token : apptoken}"
  //     },
  //   );
  //   log(res.statusCode.toString());
  //   if (res.statusCode == 200) {
  //     isLoading.value = false;
  //     var user = jsonDecode(res.body);
  //     variableId = user['variableId'];
  //     promoCode = user['promoCode'];
  //     contactUs = user['contactUs'];
  //     address = user['address'];
  //     email = user['email'];
  //     log(res.body);
  //   } else {
  //     isLoading.value = false;
  //     print('error');
  //   }
  // }
