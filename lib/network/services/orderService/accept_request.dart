import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/services/orderService/filter_controller.dart';
import 'package:smartsewa/network/services/orderService/request_service.dart';
import '../../base_client.dart';
import '../authServices/auth_controller.dart';

class AcceptServices extends GetxController {
  var isLoading = false.obs;
  DateTime dateTime = DateTime.now();
  final controller = Get.put(AuthController());
  final filterController = Get.put(FilterController());
  final orderController = Get.put(OrderController());
  final baseUrl = BaseClient().baseUrl;

  var now = DateFormat('yyyy-MM-dd').format(DateTime.now());

  DateTime yesterday = DateTime(2023, 04, 03, 09, 30);

  //final baseUrl = "http://10.0.2.2:9000";
  var orderDate;
  var completedDate;
  var serviceId;
  var parsedOrderDate;

  acceptRequestService(orderId) async {
    // getRequestService(orderId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get Servie at init $apptoken');
    // log('get sedrviecs ${controller.token}');
    isLoading.value = true;
    final response = await http.put(
      Uri.parse("$baseUrl/api/v1/workOrders/$orderId"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
      body: jsonEncode(
        <String, dynamic>{
          "orderId": orderId,
          "serviceProviderId": id,
          "chat": true,
          "orderDate": orderDate,
          "completedDate": completedDate,
        },
      ),
    );
    if (response.statusCode == 200) {
      isLoading.value = false;
      orderController.getAllRequest();
      print('put works');
    } else {
      isLoading.value = false;
    }
  }

  getRequestService(orderID) async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get Servie at init $apptoken');
    // log('get sedrviecs ${controller.token}');

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/workOrders/$orderID"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
    );
    if (response.statusCode == 200) {
      isLoading.value = false;
      print('NO ERROR');
      final jsonList = json.decode(response.body);
      orderDate = jsonList["orderDate"];
      completedDate = jsonList["completedDate"];
      serviceId = jsonList["serviceProviderId"];
    } else {
      isLoading.value = false;
      print('DATE error');
    }
  }
}
