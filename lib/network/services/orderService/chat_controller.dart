import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/models/chat_model.dart';
import '../../base_client.dart';
import '../authServices/auth_controller.dart';

class ChatController extends GetxController {
  var isLoading = false.obs;
  final controller = Get.put(AuthController());
  var chat = <ChatModel>[].obs;
  var userId;

  final baseUrl = BaseClient().baseUrl;

  //final baseUrl = "http://10.0.2.2:9000";

  getChatDetail(orderId, {bool isFirstTime = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get Servie at init $apptoken');
    // log('get sedrviecs ${controller.token}');
    if (isFirstTime) isLoading.value = true;

    final response = await http.get(
      Uri.parse("$baseUrl/api/v1/workOrder/$orderId/chats"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
    );
    log("getChatDetail :: $baseUrl/api/v1/workOrder/$orderId/chats");
    print(response.statusCode);

    if (response.statusCode == 200) {
      if (isFirstTime) isLoading.value = false;
      var jsonList = jsonDecode(response.body);
      chat.assignAll(
        (jsonList as List)
            .map(
              (product) => ChatModel.fromJson(product),
            )
            .toList(),
      );
      log("This is chat details: ${response.body}");
    } else {
      if (isFirstTime) isLoading.value = false;
    }
  }

  var dateTime;

  getDate() {
    DateTime dateTimee = DateTime.now();
    print(dateTimee);
    dateTime = DateFormat('yyyy-MM-dd\'T\'HH:mm:ss').format(dateTimee);
    print(dateTime);
  }

  postChat(orderId, String chatDetail, serviceId) async {
    getDate();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get Servie at init $apptoken');
    // log('get sedrviecs ${controller.token}');
    // isLoading.value = true;
    print("Order id is: $orderId");
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/workOrder/$orderId/chats"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
      body: jsonEncode(
        <String, dynamic>{
          "userId": id,
          "chatId": 1,
          // "chatDate": dateTime,
          "details": chatDetail.toString(),
          "chatParty": id,
          "providerId": serviceId
        },
      ),
    );

    print(response.statusCode);
    log("This is post chat: ${response.body}");
    if (response.statusCode == 201) {
      // chat.add(ChatModel(
      //   chatId: 1,
      //   details: chatDetail.toString(),
      //   userId: id,
      // ));
      getChatDetail(orderId, isFirstTime: false);

      // isLoading = false.obs;
    } else {}
  }
}
