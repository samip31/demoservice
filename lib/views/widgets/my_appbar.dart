import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/services/orderService/status_controller.dart';
import 'package:smartsewa/views/widgets/custom_dialogs.dart';

AppBar myAppbar(
  context,
  back,
  String name, {
  Widget? leading,
  bool isChat = false,
  bool isServiceProvider = false,
  String? workOrderId,
  String? completedStatus,
}) {
  StatusController statusController = StatusController();
  return !isChat
      ? AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Color(0xFF86E91A)),
          automaticallyImplyLeading: back,
          leading: leading,
          centerTitle: true,
          title: Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ))
      : AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: back,
          centerTitle: true,
          title: Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
          actions: [
            completedStatus == null || completedStatus == "2"
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {
                          Get.dialog(AlertDialog(
                            title: const Text(
                              'Complete?',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black),
                            ),
                            content: Text(completedStatus == null
                                ? 'Do you want to complete the work?'
                                : "Did you recieve the payment?"),
                            actions: [
                              TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text(
                                    'NO',
                                    style: TextStyle(color: Colors.red),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                    CustomDialogs.fullLoadingDialog(
                                        context: context);
                                    statusController.updateStatusWorkOrder(
                                        workOrderId,
                                        completedStatusCode:
                                            completedStatus == null ? 1 : 3,
                                        isFromSP: true);
                                    // isServiceProvider ? null : showRatingDialog();
                                  },
                                  child: const Text(
                                    'YES',
                                    style: TextStyle(color: Colors.green),
                                  )),
                            ],
                          ));
                        },
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 30,
                        )),
                  )
                : Container(),
          ],
        );
}

final rating = 0.obs;

showRatingDialog({
  String? workOrderId,
  String? completedStatus,
  required BuildContext context,
}) {
  Timer timer;
  StatusController statusController = StatusController();
  consolelog("completedStatus :: $completedStatus");
  Get.defaultDialog(
    title: "Rate our service",
    content: Obx(() => RatingBar.builder(
          initialRating: rating.value.toDouble(),
          itemCount: 5,
          itemBuilder: (context, index) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
            );
          },
          onRatingUpdate: (value) {
            rating.value = value.toInt();
          },
        )),
    actions: [
      // ElevatedButton(
      //   onPressed: () {
      //     Get.back();
      //   },
      //   child: const Text("Cancel"),
      // ),
      ElevatedButton(
        onPressed: () {
          // submitRating(rating.value);rating.value
          Get.back();
          CustomDialogs.fullLoadingDialog(context: context);
          statusController.updateStatusWorkOrder(workOrderId,
              completedStatusCode: 4);
          // timer = Timer(const Duration(milliseconds: 500), () {
          //   rating.value = 0;
          // });
        },
        child: const Text("Submit"),
      ),
    ],
  );
}
