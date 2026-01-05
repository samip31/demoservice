import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/services/orderService/filter_controller.dart';
import 'package:smartsewa/views/user_screen/chat/chat_screen_service.dart';
import '../../../network/services/authServices/auth_controller.dart';
import '../../../network/services/orderService/request_service.dart';

class OngoingServices extends StatefulWidget {
  const OngoingServices({super.key});

  @override
  State<OngoingServices> createState() => _OngoingServicesState();
}

class _OngoingServicesState extends State<OngoingServices> {
  final orderController = Get.put(OrderController());
  final controller = Get.put(FilterController());
  final idController = Get.put(AuthController());
  @override
  void initState() {
    getToken();
    super.initState();
  }

  int? id;
  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");
    setState(() {
      id = tid;
    });
  }

  @override
  Widget build(BuildContext contText) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (controller.userDetail.isEmpty) {
          return const Center(
            child: Text(
              'Please wait for the data to load',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: controller.userDetail.length,
              itemBuilder: (context, index) {
                final product = orderController.myProduct
                    .where((product) => product.serviceProviderId == id)
                    .toList()[index];

                return Padding(
                  padding: EdgeInsets.only(bottom: size.aspectRatio * 15),
                  child: ListTile(
                      onTap: () {
                        Get.to(() => ChatScreenService(
                              firstName: controller.userDetail[index].firstName,
                              lastName: controller.userDetail[index].lastName,
                              serviceId: product.serviceProviderId.toString(),
                              orderId: product.orderId.toString(),
                              userId: product.user?.id.toString() ?? "",
                              completedStatus: product.completedStatus ?? "0",
                            ));
                      },
                      contentPadding: EdgeInsets.symmetric(
                          vertical: size.aspectRatio * 0.07,
                          horizontal: size.aspectRatio * 20),
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "${controller.userDetail[index].firstName}  ${controller.userDetail[index].lastName}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      trailing: const Text('222')),
                );
              },
            ),
          );
        }
      },
    );
  }
}
