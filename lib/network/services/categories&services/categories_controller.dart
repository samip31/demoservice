import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import '../../models/categories_model.dart';

class CatController extends GetxController {
  String baseUrl = BaseClient().baseUrl;
  String? apptoken;

  final _controller = Get.put(AuthController());
  var isLoading = false.obs;
  var products = <Categories>[].obs;
  List getTitle = [];

  @override
  void onInit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apptoken = prefs.getString("token");
    log('Get categories token $apptoken');
    getCategories();

    super.onInit();
  }

  getCategories() async {
    try {
      isLoading.value = true;
      final res = await http.get(
        Uri.parse('$baseUrl/api/categories/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      // log("this is status: ${res.statusCode}");
      // consolelog("getCategories :: $baseUrl/api/categories/");
      // consolelog(res.body);
      if (res.statusCode == 200) {
        log('category fetched:::::');
        final jsonList = json.decode(res.body);
        jsonList.forEach((data) {
          // print(data['categoryTitle']);
          if (!getTitle.contains(data['categoryTitle'])) {
            getTitle.add(data['categoryTitle']);
          }
        });

        // log(" this is category title: $getTitle");
        products.assignAll(
          (jsonList as List)
              .map(
                (product) => Categories.fromJson(product),
              )
              .toList(),
        );
      } else {
        // throw Exception("Error loading data");
        consolelog("error");
      }
    } finally {
      isLoading(false);
    }
  }
}
