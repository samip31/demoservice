import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/network/services/orderService/request_service.dart';
import 'package:smartsewa/network/services/userdetails/current_user_controller.dart';
import 'package:smartsewa/views/user_screen/drawer%20screen/privacypolicyscreen.dart';
import 'package:smartsewa/views/serviceProviderScreen/service_main_screen.dart';
import 'package:smartsewa/views/user_screen/order_status/service_status.dart';
import 'package:url_launcher/url_launcher.dart';
import '../user_screen/drawer screen/about_us.dart';
import '../user_screen/drawer screen/contact_screen.dart';

List name = [
  'Service Status',
  'Terms & Conditions',
  'Privacy Policy',
  'About Us',
  'Contact',
];
List icon = [
  Icons.downloading,
  Icons.book_outlined,
  Icons.privacy_tip_outlined,
  CupertinoIcons.question_circle,
  CupertinoIcons.phone,
];
List screen = [
  // const SentRequest(),
  const ServiceStatus(),
  const PrivacypolicyScreen(),
  null,
  const AboutUS(),
  const ContactScreen(),
];

Future<void> urlLaunch(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.inAppWebView,
  )) {
    throw 'Error launching URL: $url';
  }
}

Drawer myDrawer(context) {
  final controller = Get.put(CurrentUserController());
  final orderController = Get.put(OrderController());
  return Drawer(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: name.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      if (index == 0) {
                        orderController.getRequestService();
                      }
                      if (screen[index] != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => screen[index],
                            ));
                      } else {
                        urlLaunch('https://smartsewa.com.np/privacy-policy');
                      }
                    },
                    title: Text(
                      name[index],
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    leading: Icon(
                      icon[index],
                      size: 25,
                      color: Theme.of(context).primaryColor,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),
          Obx(() {
            // logger("drawer :: ${controller.currentUserData.value.workStatus}");
            return controller.currentUserData.value.workStatus == true
                ? Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => const ServiceMainScreen());
                      },
                      title: const Text(
                        "Service Provider",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      leading: Icon(
                        Icons.logout_outlined,
                        size: 25,
                        color: Theme.of(context).primaryColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.black,
                      ),
                    ),
                  )
                : Container();
          })
          // Card(
          //   child: ListTile(
          //     onTap: () {
          //       MyDialogs().myAlert(
          //           context, 'Logout!!', 'Are you sure, you want to logout?',
          //           () {
          //         Get.back();
          //       }, () {
          //         Get.offAll(const LoginScreen());
          //       });
          //     },
          //     title: const Text(
          //       "Logout",
          //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          //     ),
          //     leading: Icon(
          //       Icons.logout_outlined,
          //       size: 25,
          //       color: Theme.of(context).primaryColor,
          //     ),
          //     trailing: const Icon(
          //       Icons.arrow_forward_ios_outlined,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
        ],
      ),
    ),
  );
}
