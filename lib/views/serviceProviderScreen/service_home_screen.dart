import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/network/services/orderService/accept_request.dart';
import 'package:smartsewa/network/services/orderService/filter_controller.dart';
import 'package:smartsewa/network/services/orderService/request_service.dart';
import 'package:smartsewa/views/serviceProviderScreen/service_main_screen.dart';
import 'package:smartsewa/views/user_screen/chat/chat_screen_service.dart';
import 'package:smartsewa/views/widgets/custom_text.dart';

class ServiceHomeScreen extends StatefulWidget {
  const ServiceHomeScreen({Key? key}) : super(key: key);

  @override
  State<ServiceHomeScreen> createState() => _ServiceHomeScreenState();
}

class _ServiceHomeScreenState extends State<ServiceHomeScreen> {
  final orderController = Get.put(OrderController());
  final controller = Get.put(FilterController());
  final idController = Get.put(AuthController());
  final acceptController = Get.put(AcceptServices());

  bool onPressed = true;

  @override
  void initState() {
    getToken();
    orderController.getServiceProviderOngoingRequestService();
    orderController.getAllRequest().then((value) {
      log("getAllRequest value :: $value");
      if (value != '') {
        orderController.getOrderId();
        // if (controller.userDetail.isEmpty) {
        //   controller.getUserDetails();
        // } else {
        //   controller.userDetail.clear();
        //   controller.getUserDetails();
        // }

        if (controller.userDetailRequest.isEmpty) {
          controller.getUserrequestDetails();
        } else {
          controller.userDetailRequest.clear();
          controller.getUserrequestDetails();
        }
      }
    });
    // orderController.getAllUserOngoingRequestService().then((value) {
    //   log("getAllUserOngoingRequestService value :: $value");
    //   if (value != '') {
    //     orderController.getOrderId();
    //     consolelog(
    //         "controller.userDetail.isEmpty :: ${controller.userDetail.isEmpty}");
    //     if (controller.userDetail.isEmpty) {
    //       controller.getUserDetails();
    //     } else {
    //       controller.userDetail.clear();
    //       controller.getUserDetails();
    //     }
    //     consolelog(
    //         "controller.userDetailRequest.isEmpty :: ${controller.userDetailRequest.isEmpty}");
    //     if (controller.userDetailRequest.isEmpty) {
    //       controller.getUserrequestDetails();
    //     } else {
    //       controller.userDetailRequest.clear();
    //       controller.getUserrequestDetails();
    //     }
    //   }
    // });
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.aspectRatio * 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Welcome to Smart \nSewa Solutions ",
                style: TextStyle(
                  fontFamily: 'hello',
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Expanded(
                  child: Image.asset(
                'assets/Logo.png',
                height: 80,
              ))
            ],
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.51,
          ),
          SizedBox(height: size.height * 0.025),
          // Expanded(
          //   child: DefaultTabController(
          //       length: 2,
          //       child: Column(
          //         children: [
          //           const TabBar(
          //             indicatorColor: Colors.greenAccent,
          //             tabs: [
          //               Tab(
          //                 child: Text(
          //                   "Ongoing Service",
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                       fontSize: 18,
          //                       color: Colors.red,
          //                       fontWeight: FontWeight.w500),
          //                 ),
          //               ),
          //               Tab(
          //                 child: Text(
          //                   "Request",
          //                   style: TextStyle(
          //                       fontSize: 18,
          //                       color: Colors.red,
          //                       fontWeight: FontWeight.w500),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Expanded(
          //             child: Padding(
          //               padding: EdgeInsets.all(size.aspectRatio * 28),
          //               child: TabBarView(children: [
          //                 OngoingServices(controller: controller),
          //                const IncomingRequest(),
          //               ]),
          //             ),
          //           )
          //         ],
          //       )),
          // ),

          // row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    onPressed = !onPressed;
                  });
                },
                child: Container(
                  width: width / 2.5,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 3,
                        color: onPressed ? Colors.green : Colors.transparent,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 4),
                  child: const Center(
                    child: Text(
                      'Ongoing Service',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    onPressed = !onPressed;
                  });
                },
                child: Container(
                  width: width / 2.5,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 3,
                        color: !onPressed ? Colors.green : Colors.transparent,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 4),
                  child: const Center(
                    child: Text(
                      'Request',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // body
          const SizedBox(
            height: 20,
          ),

          Expanded(child: onPressed ? ongoing() : incomingrequest()),
        ],
      ),
    );
  }

  ongoing() {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return orderController.serviceProviderOngoingResponseData.value
                      .workOrders?.isEmpty ??
                  false
              ? Center(
                  child: CustomText.ourText("Empty"),
                )
              : Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: orderController
                            .serviceProviderOngoingResponseData.value.workOrders
                            ?.where((element) => element.chat == true)
                            .length ??
                        0,
                    itemBuilder: (context, index) {
                      final product = orderController
                          .serviceProviderOngoingResponseData.value.workOrders
                          ?.where((element) => element.chat == true)
                          .toList()[index];

                      return Padding(
                        padding: EdgeInsets.only(bottom: size.aspectRatio * 15),
                        child: ListTile(
                          onTap: () {
                            Get.to(() => ChatScreenService(
                                  firstName: product?.user?.firstName ?? "",
                                  lastName: product?.user?.lastName ?? "",
                                  serviceId:
                                      product?.serviceProviderId.toString() ??
                                          "",
                                  orderId: product?.orderId.toString() ?? "",
                                  userId: product?.userId.toString() ?? "",
                                  completedStatus: product?.completedStatus,
                                ));
                          },
                          contentPadding: EdgeInsets.symmetric(
                            vertical: size.aspectRatio * 0.07,
                            horizontal: size.aspectRatio * 20,
                          ),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "${product?.user?.firstName}  ${product?.user?.lastName}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          trailing: const Text('Chat'),
                        ),
                      );
                    },
                  ),
                );
        }
      }),
    );
  }
  // ongoing() {
  //   Size size = MediaQuery.sizeOf(context);

  //   return Scaffold(
  //     body: Obx(() {
  //       if (controller.isLoading.value) {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else if (orderController.isLoading.value) {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else {
  //         return controller.userDetail.isEmpty
  //             ? Center(
  //                 child: CustomText.ourText("Empty"),
  //               )
  //             : Container(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: ListView.builder(
  //                   itemCount: controller.userDetail.length,
  //                   itemBuilder: (context, index) {
  //                     final product = orderController.myProduct
  //                         .where((product) =>
  //                             product.serviceProviderId == id &&
  //                             product.chat == true)
  //                         .toList()[index];
  //                     inspect(product);

  //                     return Padding(
  //                       padding: EdgeInsets.only(bottom: size.aspectRatio * 15),
  //                       child: ListTile(
  //                         onTap: () {
  //                           Get.to(() => ChatScreenService(
  //                                 firstName:
  //                                     controller.userDetail[index].firstName,
  //                                 lastName:
  //                                     controller.userDetail[index].lastName,
  //                                 serviceId:
  //                                     product.serviceProviderId.toString(),
  //                                 orderId: product.orderId.toString(),
  //                                 userId: product.userId.toString(),
  //                                 completedStatus: product.completedStatus,
  //                               ));
  //                         },
  //                         contentPadding: EdgeInsets.symmetric(
  //                           vertical: size.aspectRatio * 0.07,
  //                           horizontal: size.aspectRatio * 20,
  //                         ),
  //                         tileColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(18),
  //                         ),
  //                         leading: Padding(
  //                           padding: const EdgeInsets.only(top: 8),
  //                           child: Text(
  //                             "${controller.userDetail[index].firstName}  ${controller.userDetail[index].lastName}",
  //                             style: const TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                         ),
  //                         trailing: const Text('Chat'),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               );
  //       }
  //     }),
  //   );
  // }

  incomingrequest() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (orderController.isLoading.value) {
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
                          log("ACCEPTING THE REQUESTED SERVICE");
                          consolelog(orderController.product);
                          acceptController.acceptRequestService(
                              orderController.product[index]);
                          // acceptController.getRequestService();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ServiceMainScreen()));
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
      }),
    );
  }
}
