import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:http/http.dart' as http;
import 'package:smartsewa/views/serviceProviderScreen/service_main_screen.dart';
import 'package:smartsewa/views/user_screen/main_screen.dart';

import '../../../views/widgets/custom_toasts.dart';
import '../../base_client.dart';

class StatusController extends GetxController {
  var isLoading = false.obs;

  final baseUrl = BaseClient().baseUrl;

  Future updateStatusWorkOrder(orderId,
      {int? completedStatusCode, bool? isFromSP, bool? rating}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    consolelog(id.toString());
    consolelog('Get status at init $apptoken');

    try {
      final response = await http.post(
        Uri.parse(
            "$baseUrl/api/v1/$orderId/update-status/$completedStatusCode"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      consolelog(
          "updateStatusWorkOrder :: $baseUrl/api/v1/$orderId/update-status/$completedStatusCode");
      consolelog(response.statusCode);
      consolelog(response.body);
      isLoading.value = false;
      Get.back();
      if (response.statusCode == 200) {
        successToast(msg: "Completed Status updated");
        isFromSP ?? false
            ? Get.offAll(() => const ServiceMainScreen())
            : rating ?? false
                ? null
                : Get.offAll(() => const MainScreen());
        return true;
      } else {
        errorToast(msg: "Error updating status");
        return false;
      }
    } catch (err) {
      Get.back();
      isLoading.value = false;
      errorToast(msg: err.toString());
      return false;
    }
  }

  ratingWorkOrder(orderId, rating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    consolelog(id.toString());
    consolelog('Get status at init $apptoken');
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/v1/rating/$id/$orderId?score=$rating"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );
      consolelog(
          "updateStatusWorkOrder :: $baseUrl/api/v1/rating/$id/$orderId?score=$rating");
      consolelog(response.statusCode);
      consolelog(response.body);
      isLoading.value = false;
      // Get.back();
      if (response.statusCode == 200) {
        successToast(msg: "Completed Status updated rating");
        Get.offAll(() => const MainScreen());
        return true;
      } else {
        errorToast(msg: "Error updating status rating");
        return false;
      }
    } catch (err) {
      // Get.back();
      isLoading.value = false;
      errorToast(msg: err.toString());
      return false;
    }
  }
}
