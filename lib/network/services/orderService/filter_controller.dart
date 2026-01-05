import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/models/detail_model.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/network/services/orderService/request_service.dart';
import 'package:http/http.dart' as http;

class FilterController extends GetxController {
  final baseUrl = BaseClient().baseUrl;

  final controller = Get.put(AuthController());
  final orderController = Get.put(OrderController());
  final isServiceStatusLoading = false.obs;

  var isLoading = false.obs;

  var serviceProviderDetailRequest = <ServiceProviderDetailModel>[].obs;

  var serviceProviderDetail = <ServiceProviderDetailModel>[].obs;

  var serviceProviderHistoryDetail = <ServiceProviderDetailModel>[].obs;

  var userDetail = <ServiceProviderDetailModel>[].obs;

  var userDetailRequest = <ServiceProviderDetailModel>[].obs;

  var listOfRequestWorkOrderId = [].obs;

  // var details = <ServiceProviderDetails>[].obs;

  List<int?> getQueryForServiceProviderIdAccordingToCondition(
      String statusType, int? id) {
    List<int?> serviceProviderId = [];
    if (statusType == "request") {
      serviceProviderId = orderController.products
          .where((product) => product.chat == false)
          .map((e) => e.serviceProviderId)
          .toList();
    } else if (statusType == "ongoing") {
      serviceProviderId = orderController.products
          .where((product) =>
              product.chat == true && product.completedStatus != "4")
          .map((e) => e.serviceProviderId)
          .toList();
    } else if (statusType == "history") {
      serviceProviderId = orderController.products
          .where((product) =>
              product.completedStatus == "4" && product.chat == true)
          .map((e) => e.serviceProviderId)
          .toList();
    }
    return serviceProviderId;
  }

  void getServiceStatusOfUser(String statusType) async {
    isServiceStatusLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      int? id = prefs.getInt("id");

      final serviceProviderId =
          getQueryForServiceProviderIdAccordingToCondition(statusType, id);

      if (serviceProviderId.isNotEmpty) {}
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ****************Service provider request info for user side********
  getServiceProviderDetailsrequest() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      int? id = prefs.getInt("id");
      log(id.toString());
      log('Get Servie at init $apptoken');
      // log('get sedrviecs ${controller.token}');
      isLoading.value = true;
      listOfRequestWorkOrderId.value = orderController.products
          .where((product) => product.user?.id == id && product.chat == false)
          .map((e) => e.orderId)
          .toList();
      consolelog(listOfRequestWorkOrderId);
      final serviceProviderId = orderController.products
          .where((product) => product.user?.id == id && product.chat == false)
          .map((e) => e.serviceProviderId)
          .toList();

      if (serviceProviderId.isEmpty) {
        isLoading.value = false;
      }

      for (var id in serviceProviderId) {
        final response = await http.get(
          Uri.parse("$baseUrl/api/users/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "Bearer  $apptoken"
          },
        );

        if (response.statusCode == 200) {
          isLoading.value = false;
          final jsonList = jsonDecode(response.body);
          String firstName = jsonList['firstName'];
          String lastName = jsonList['lastName'];
          String work = jsonList['serviceProvided'];
          serviceProviderDetailRequest
              .add(ServiceProviderDetailModel.fromJson(jsonList));
        } else {
          isLoading.value = false;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ***************Service provider ongoing info for user side**************
  getServiceProviderDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      int? id = prefs.getInt("id");
      log(id.toString());
      log('Get service details init $apptoken');
      // log('get service detail ${controller.token}');
      isLoading.value = true;

      final serviceProviderId = orderController.products
          .where((product) =>
              product.user?.id == id &&
              product.chat == true &&
              product.completedStatus != "4")
          .map((e) => e.serviceProviderId)
          .toList();
      logger(serviceProviderId);

      if (serviceProviderId.isEmpty) {
        isLoading.value = false;
      }

      for (var id in serviceProviderId) {
        final response = await http.get(
          Uri.parse("$baseUrl/api/users/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "Bearer  $apptoken"
          },
        );

        if (response.statusCode == 200) {
          isLoading.value = false;
          final jsonList = jsonDecode(response.body);

          serviceProviderDetail
              .add(ServiceProviderDetailModel.fromJson(jsonList));
        } else {
          isLoading.value = false;
          print("error");
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ***************Service provider history info for user side**************
  getServiceProviderHistoryDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? apptoken = prefs.getString("token");
      int? id = prefs.getInt("id");
      log(id.toString());
      log('Get service history details init $apptoken');
      // log('get service detail ${controller.token}');
      isLoading.value = true;

      final serviceProviderId = orderController.products
          .where((product) =>
              product.user?.id == id &&
              product.chat == true &&
              product.completedStatus == "4")
          .map((e) => e.serviceProviderId)
          .toList();
      logger(serviceProviderId);

      if (serviceProviderId.isEmpty) {
        isLoading.value = false;
      }

      for (var id in serviceProviderId) {
        final response = await http.get(
          Uri.parse("$baseUrl/api/users/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "Bearer  $apptoken"
          },
        );

        if (response.statusCode == 200) {
          isLoading.value = false;
          final jsonList = jsonDecode(response.body);

          serviceProviderHistoryDetail
              .add(ServiceProviderDetailModel.fromJson(jsonList));
        } else {
          isLoading.value = false;
          print("error");
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // *****************User ongoing info for service provider side************
  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get user init $apptoken');
    // log('get user ${controller.token}');
    isLoading.value = true;

    final userId = orderController.myProduct
        .where((product) =>
            product.serviceProviderId == id && product.chat == true)
        .map((e) => e.user?.id)
        .toList();

    if (userId.isEmpty) {
      isLoading.value = false;
    }

    try {
      for (var id in userId) {
        final response = await http.get(
          Uri.parse("$baseUrl/api/users/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "Bearer  $apptoken"
          },
        );
        consolelog("getUserDetails :: $baseUrl/api/users/$id");
        // consolelog(response.statusCode);
        // consolelog(response.body);
        if (response.statusCode == 200) {
          isLoading.value = false;
          final jsonList = jsonDecode(response.body);
          String firstName = jsonList['firstName'];
          String lastName = jsonList['lastName'];
          userDetail.add(ServiceProviderDetailModel.fromJson(jsonList));
        } else {
          isLoading.value = false;
          print("error");
        }
      }
    } catch (e) {
      isLoading.value = false;
      throw Exception(e.toString());
    }
  }

  // ******************User request infor for service provider side**************
  getUserrequestDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get user init $apptoken');
    // log('get user ${controller.token}');
    isLoading.value = true;

    final userId = orderController.myProduct
        .where((product) =>
            product.serviceProviderId == id && product.chat == false)
        .map((e) => e.user?.id)
        .toList();
    if (userId.isEmpty) {
      isLoading.value = false;
    }

    try {
      for (var id in userId) {
        final response = await http.get(
          Uri.parse("$baseUrl/api/users/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "Bearer  $apptoken"
          },
        );
        consolelog("getUserrequestDetails :: $baseUrl/api/users/$id");
        // consolelog(response.statusCode);
        // consolelog(response.body);

        if (response.statusCode == 200) {
          isLoading.value = false;

          final jsonList = jsonDecode(response.body);

          userDetailRequest.add(ServiceProviderDetailModel.fromJson(jsonList));
        } else {
          isLoading.value = false;
          print("error");
        }
      }
    } catch (e) {
      isLoading.value = false;
      throw Exception(e.toString());
    }
  }
}
