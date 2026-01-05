import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/models/order_request_model.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/views/user_screen/order_status/service_status.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import '../../../core/enum.dart';
import '../../base_client.dart';
import '../../models/service_provider_response_model.dart';

class OrderController extends GetxController {
  final baseUrl = BaseClient().baseUrl;
  final controller = Get.put(AuthController());
  var products = <UserServicesListResponse>[].obs;
  final requestedServicesList = <UserServicesListResponse>[].obs;
  final ongoingServicesList = <UserServicesListResponse>[].obs;
  final historyServicesList = <UserServicesListResponse>[].obs;
  var myProduct = <UserServicesListResponse>[].obs;
  Rx<ServiceProviderOngoingResponseModel> serviceProviderOngoingResponseData =
      ServiceProviderOngoingResponseModel().obs;
  var isLoading = false.obs;
  var dateTime;
  var serviceProviderId;
  var product;

  @override
  void onInit() {
    // getRequestService();
    super.onInit();
  }

  getOrderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    product = myProduct
        .where((product) =>
            product.serviceProviderId == id && product.chat == false)
        .map((e) => e.orderId)
        .toList();
  }

  getDate() {
    DateTime dateTimee = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd\'T\'HH:mm:ssZ').format(now);
    dateTime = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').format(dateTimee);
  }

  requestService(int serviceId) async {
    getDate();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");
    log(tid.toString());
    log('Get user init $apptoken');
    // log('get user ${controller.token}');
    isLoading.value = true;
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/user/$tid/workOrders"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken}"
      },
      body: jsonEncode(
        <String, dynamic>{
          "serviceProviderId": serviceId,
          "chat": false,
          "orderDate": dateTime,
          "completedDate": dateTime,
          "userId": tid
        },
      ),
    );
    // consolelog("request_service :: $baseUrl/api/v1/user/$tid/workOrders");
    // consolelog(response.statusCode);
    // consolelog(response.body);
    if (response.statusCode == 201) {
      getRequestService();
      Get.to(() => const ServiceStatus());
    } else {
      consolelog('map error');
    }
  }

  // This is the main function for getting all the request of the user and in this function we have classified the request into three categories i.e. requestedServicesList, ongoingServicesList and historyServicesList. standing for the request that are not accepted by the service provider, ongoing request and the request that are completed respectively in the three tabs Screen. ------ Note:  This will be called when the user clicks on the Service Status button of the app drawer. -------

  void getRequestService() async {
    // clearing the list before adding the new data to the list removing this line will cause the list to be appended with the new data every time the function is called. i.e if the list has 3 items and the function is called again then the list will have 6 items. causing the list to be duplicated. ------
    requestedServicesList.clear();
    ongoingServicesList.clear();
    historyServicesList.clear();
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/user/$id/workOrders"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;

        final jsonList = json.decode(response.body);

        jsonList.forEach((service) {
          if (service["chat"] == false) {
            requestedServicesList
                .add(UserServicesListResponse.fromJson(service));
          } else if (service["chat"] == true &&
              service["completedStatus"] != "4") {
            ongoingServicesList.add(UserServicesListResponse.fromJson(service));
          } else if (service["chat"] == true &&
              service["completedStatus"] == "4") {
            historyServicesList.add(UserServicesListResponse.fromJson(service));
          }
        });
      } else {
        isLoading.value = false;
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  // SERVICE PROVIDER REQUESTS

  getAllRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/workOrders"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        log("GET ALL SERVICE PRIOVIDER REQUESTS : ${response.body}");
        final jsonList = json.decode(response.body);
        jsonList.forEach((service) {
          myProduct.add(UserServicesListResponse.fromJson(service));
        });
      } else {
        isLoading.value = false;
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  getServiceProviderOngoingRequestService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/v1/serviceProvider/$id/workOrders"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        serviceProviderOngoingResponseData.value =
            serviceProviderOngoingResponseModelFromJson(response.body);
      } else {
        isLoading.value = false;
        errorToast(
            msg: "Failed to fetch the ongoing request of service provider");
      }
    } catch (err) {
      isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  // request cancel
  Future<bool> requestServiceCancel(int workOrderId) async {
    logger(workOrderId, loggerType: LoggerType.success);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");

    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/api/v1/workOrders/$workOrderId"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );

      if (response.statusCode == 200) {
        successToast(msg: "Request has been cancelled successfully.");
        return true;
      } else {
        errorToast(msg: "Error cancelling request.");
        return false;
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      return false;
    }
  }
}
