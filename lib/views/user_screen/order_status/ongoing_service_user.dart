import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/views/user_screen/chat/chat_screen.dart';
import '../../../network/services/orderService/request_service.dart';

class OngoingServiceUser extends StatefulWidget {
  const OngoingServiceUser({
    Key? key,
  }) : super(key: key);

  @override
  State<OngoingServiceUser> createState() => _OngoingServiceUserState();
}

class _OngoingServiceUserState extends State<OngoingServiceUser> {
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => orderController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orderController.ongoingServicesList.isEmpty
              ? const Center(
                  child: Text(
                    "No Ongoing Services",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    orderController.getRequestService();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: orderController.ongoingServicesList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: size.aspectRatio * 15),
                          child: ListTile(
                            onTap: () {
                              Get.to(() => ChatScreen(
                                    serviceId: orderController
                                        .ongoingServicesList[index]
                                        .serviceProviderId
                                        .toString(),
                                    orderId: orderController
                                        .ongoingServicesList[index].orderId
                                        .toString(),
                                    firstName: orderController
                                        .ongoingServicesList[index]
                                        .serviceProvider!
                                        .firstName
                                        .toString(),
                                    lastName: orderController
                                        .ongoingServicesList[index]
                                        .serviceProvider!
                                        .lastName
                                        .toString(),
                                    userId: orderController
                                        .ongoingServicesList[index].user!.id
                                        .toString(),
                                    completedStatus: orderController
                                            .ongoingServicesList[index]
                                            .completedStatus ??
                                        "0",
                                  ));
                            },
                            contentPadding: EdgeInsets.symmetric(
                                // vertical: size.aspectRatio * 15,
                                horizontal: size.aspectRatio * 20),
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            leading: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  orderController.ongoingServicesList[index]
                                      .serviceProvider!.fullname
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  orderController.ongoingServicesList[index]
                                      .serviceProvider!.serviceProvided
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            trailing: const Column(
                              children: [
                                Text("Chat"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'ongoing',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
