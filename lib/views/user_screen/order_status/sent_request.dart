import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../network/services/orderService/request_service.dart';

class SentRequest extends StatefulWidget {
  const SentRequest({Key? key}) : super(key: key);

  @override
  State<SentRequest> createState() => _SentRequestState();
}

class _SentRequestState extends State<SentRequest> {
  final orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => orderController.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orderController.requestedServicesList.isEmpty
              ? const Center(
                  child: Text(
                    "No Requested Services",
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8),
                    child: ListView.builder(
                      itemCount: orderController.requestedServicesList.length,
                      itemBuilder: (context, index) {
                        log("REQESTED SERVICES LIST: ${orderController.requestedServicesList.length}");
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        orderController
                                            .requestedServicesList[index]
                                            .serviceProvider!
                                            .fullname
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    Text(
                                        orderController
                                            .requestedServicesList[index]
                                            .serviceProvider!
                                            .serviceProvided
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        )),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Sent'),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: 'Cancel Request',
                                            middleText:
                                                'Do you want to proceed?',
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  final cancellationSuccessful =
                                                      await orderController
                                                          .requestServiceCancel(
                                                    orderController
                                                        .requestedServicesList[
                                                            index]
                                                        .orderId!,
                                                  );
                                                  if (cancellationSuccessful) {
                                                    orderController
                                                        .getRequestService();
                                                  } else {
                                                    Get.snackbar(
                                                      'Error',
                                                      'Failed to cancel the request. Please try again later.',
                                                      backgroundColor:
                                                          Colors.red,
                                                      colorText: Colors.white,
                                                    );
                                                  }
                                                },
                                                child: const Text('Yes'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text('No'),
                                              ),
                                            ]);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          backgroundColor: Colors.red,
                                          minimumSize: const Size(30.0, 30.0)),
                                      child: const Text(
                                        'Cancel Request',
                                        style: TextStyle(fontSize: 13.0),
                                      ),
                                    )
                                  ],
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
