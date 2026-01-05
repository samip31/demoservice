import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/services/orderService/accept_request.dart';
import 'package:smartsewa/network/services/orderService/filter_controller.dart';
import '../../../network/services/orderService/request_service.dart';

class IncomingRequest extends StatefulWidget {
  const IncomingRequest({Key? key}) : super(key: key);

  @override
  State<IncomingRequest> createState() => _IncomingRequestState();
}

class _IncomingRequestState extends State<IncomingRequest> {
  // final idCOntroller = Get.put(AuthController());
  final orderController = Get.put(OrderController());
  final controller = Get.put(FilterController());
  final acceptController = Get.put(AcceptServices());
  int? tid;
  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    setState(() {
      tid = id;
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: controller.userDetailRequest.length,
              itemBuilder: (context, index) {
                final product = orderController.myProduct
                    .where((product) =>
                        product.serviceProviderId == tid &&
                        product.chat == false)
                    .toList()[index];

                return Padding(
                  padding: EdgeInsets.only(bottom: size.aspectRatio * 15),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: size.aspectRatio * 15,
                        horizontal: size.aspectRatio * 20),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    leading: Text(
                      "${controller.userDetailRequest[index].firstName} ${controller.userDetailRequest[index].lastName}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          acceptController
                              .acceptRequestService(product.orderId);
                          acceptController.getRequestService(product.orderId);
                          orderController.getAllRequest();
                        },
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.greenAccent,
                          size: 30,
                        )),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
