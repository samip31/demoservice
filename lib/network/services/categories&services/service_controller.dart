import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/services/categories&services/categories_controller.dart';

import '../../base_client.dart';
import '../../models/servicemodel.dart';
import '../authServices/auth_controller.dart';

class ServicesController extends GetxController {
  String baseUrl = BaseClient().baseUrl;
  final controller = Get.put(AuthController());
  final categoryController = Get.find<CatController>();
  var products = <ServicesList>[].obs;
  Map<dynamic, List<dynamic>> filterSubCategory = {};

  // @override
  // void onInit() {
  //   fetchServices();
  //   super.onInit();
  // }

  fetchServices() async {
    filterSubCategory.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get services init $apptoken');
    // log('get service ${controller.token}');
    final res = await http.get(
      Uri.parse('$baseUrl/api/services'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
    );
    consolelog("fetchServices :: $baseUrl/api/services");
    consolelog(res.statusCode);
    // consolelog(res.body);
    final jsonList = json.decode(res.body);
    jsonList.forEach((data) {
      for (var category in categoryController.getTitle) {
        if (category == data['category']['categoryTitle']) {
          filterSubCategory.putIfAbsent(category, () => []).add(data['name']);
        }
      }
    });
    // log("filter data : $filterSubCategory");
    products.assignAll(
      (jsonList as List)
          .map(
            (product) => ServicesList.fromJson(product),
          )
          .toList(),
    );
  }
}
