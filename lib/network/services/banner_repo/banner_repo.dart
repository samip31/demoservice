import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../base_client.dart';

class BannerImageController extends GetxController {
  String baseUrl = BaseClient().baseUrl;
  RxList<String> topBanners = <String>[].obs;
  RxList<String> bottomBanners = <String>[].obs;

  Future<void> fetchImages() async {
    final url = '$baseUrl/api/allimg/images';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apptoken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print('feteched:::::::::: Images');

        if (jsonData.containsKey("topBanners")) {
          topBanners.assignAll(
              (jsonData["topBanners"] as List<dynamic>).cast<String>());
        }

        if (jsonData.containsKey("bottomBanners")) {
          bottomBanners.assignAll(
              (jsonData["bottomBanners"] as List<dynamic>).cast<String>());
        }
        saveImagesToSharedPreferences();
      } else {
        print('Failed to load images. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while fetching images: $e');
    }
  }

  Future<void> saveImagesToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving topBanners to SharedPreferences: ${topBanners.toList()}');
    print(
        'Saving bottomBanners to SharedPreferences: ${bottomBanners.toList()}');
    // Save topBanners and bottomBanners to SharedPreferences
    prefs.setStringList('topBanners', topBanners.toList());
    prefs.setStringList('bottomBanners', bottomBanners.toList());
  }

  Future<void> loadImagesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve topBanners and bottomBanners from SharedPreferences
    final topBannersFromPrefs = prefs.getStringList('topBanners') ?? [];
    final bottomBannersFromPrefs = prefs.getStringList('bottomBanners') ?? [];

    // Update the RxList properties with the loaded data
    topBanners.assignAll(topBannersFromPrefs);
    bottomBanners.assignAll(bottomBannersFromPrefs);
  }

 //----------------------hash----------------------------

}
