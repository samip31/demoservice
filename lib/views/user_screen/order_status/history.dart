import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartsewa/core/dimension.dart';

import '../../../network/services/orderService/request_service.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => orderController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orderController.historyServicesList.isEmpty
              ? const Center(
                  child: Text(
                    "No History Services",
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
                    padding: screenLeftRightPadding,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: orderController.historyServicesList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: size.aspectRatio * 16, top: 8),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: size.aspectRatio * 15,
                                horizontal: size.aspectRatio * 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            tileColor: Colors.white,
                            leading: const Icon(
                              CupertinoIcons.house_fill,
                              color: Colors.black,
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  orderController.historyServicesList[index]
                                      .serviceProvider!.fullname
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  // format the completed date as 26 May 2021
                                  DateFormat.yMMMd().format(orderController
                                      .historyServicesList[index]
                                      .completedDate!),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                            title: Text(
                              orderController.ongoingServicesList[index]
                                  .serviceProvider!.serviceProvided
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
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
