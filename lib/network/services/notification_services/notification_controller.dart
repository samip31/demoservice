import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/enum.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:http/http.dart' as http;
import 'package:smartsewa/network/models/common_response_model.dart';
import 'package:smartsewa/network/models/notification_model/admin_model.dart';
import 'package:smartsewa/network/models/notification_model/user_model.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';

class NotificationController extends GetxController {
  final adminNotifications = <AdminNotificationModel>[].obs;
  final userNotifications = <UserNotificationModel>[].obs;

  var isLoading = false.obs;
  String baseUrl = BaseClient().baseUrl;

  var seenStatus = false.obs;

  @override
  void onInit() {
    fetchAdminNotification();
    fetchUserNotifications();
    super.onInit();
  }

  void fetchAdminNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    // log('get contact ${controller.token}');
    isLoading.value = true;
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/adminNotifications'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
    );
    log(res.statusCode.toString());

    isLoading.value = false;
    if (res.statusCode == 200) {
      print('admin notification fetched');
      final List<dynamic> data = json.decode(res.body);
      final List<AdminNotificationModel> notifications = data
          .map((data) => AdminNotificationModel(
                adminNotificationId: data['adminNotificationId'],
                title: data['title'],
                information: data['information'],
                dateAndTime: data['dateAndTime'],
                historyStatus: data['historyStatus'],
              ))
          .toList();
      adminNotifications.assignAll(notifications);

      // log(res.body);
    } else {
      print('error');
    }
  }

  Future<List<dynamic>?> fetchUserNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    // log('get contact ${controller.token}');
    isLoading.value = true;
    final res = await http.get(
      Uri.parse('$baseUrl/api/v1/user/$id/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
    );
    consolelog(
        "fetchUserNotifications :: $baseUrl/api/v1/user/$id/notifications");
    consolelog(res.statusCode);
    // consolelog(res.body);

    isLoading.value = false;
    if (res.statusCode == 200) {
      final List<dynamic> userData = jsonDecode(res.body);
      final List<UserNotificationModel> notifications = userData
          .map((data) => UserNotificationModel(
                notificationId: data['notificationId'],
                notificationType: data['notificationType'] ?? "",
                information: data['information'] ?? "",
                dateAndTime: data['dateAndTime'],
                seen: data['seen'],
                historyStatus: data['historyStatus'],
                usedBy: data['usedBy'] ?? "",
                details: data['details'] ?? "",
              ))
          .toList();
      userNotifications.assignAll(notifications);
      consolelog(userNotifications);
      return userData;
    } else {
      print('error');
    }
    return null;
  }

  Future fetchUserNotificationsSeenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    // isLoading.value = true;
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/api/v1/seen/$id/notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      log("User NOTIFCATION FETCHING CONTROLLER");
      consolelog('$baseUrl/api/v1/seen/$id/notifications');
      consolelog(res.statusCode);
      consolelog(res.body);

      // isLoading.value = false;
      if (res.statusCode == 200) {
        var result = commonResponseModelFromJson(res.body);
        logger(result, loggerType: LoggerType.success);
        seenStatus.value = result.success ?? false;
      } else {
        errorToast(msg: "Error in fetching notification seen status");
      }
    } catch (err) {
      // isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }

  // Update notification's "seen" status
  Future<void> updateNotificationSeenStatus(int notificationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");

    log("This is notification id: $notificationId");
    final url = '$baseUrl/api/v1/notifications/$notificationId';
    final response = await http.put(
      Uri.parse(
        url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
      body: jsonEncode({'seen': true}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update notification seen status');
    }
  }

  Future updateUserNotificationsSeenStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");

    try {
      // isLoading.value = true;
      final res = await http.put(
        Uri.parse('$baseUrl/api/v1/user/$id/notifications/updateSeenStatus'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      consolelog(
          "updateUserNotificationsSeenStatus :: $baseUrl/api/v1/user/$id/notifications/updateSeenStatus");
      consolelog(res.statusCode);
      consolelog(res.body);

      // isLoading.value = false;
      if (res.statusCode == 200) {
        // CustomSnackBar.showSnackBar(
        //   title: "Successfully updated seen status",
        // );
        fetchUserNotificationsSeenStatus();
      } else {
        errorToast(msg: "Error updating user notifications seen status");
      }
    } catch (err) {
      // isLoading.value = false;
      errorToast(msg: err.toString());
    }
  }
}
