import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:smartsewa/network/services/orderService/accept_request.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  void onPressed() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
          amount: 10, productIdentity: "asdsad", productName: "asdsad"),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: (su) {
        const successSnackBar = SnackBar(
          content: Text('Payment Successful'),
        );
        ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
        // if (widget.serviceType == 'offer') {
        //   Get.to(() => const UploadOffer());
        // } else if (widget.serviceType == 'vacancy') {
        //   Get.to(() => const UploadVaccancy());
        // } else {
        //   Get.to(() => const UploadSecondHand());
        // }
      },
      onFailure: (fa) {
        const failedSnackBar = SnackBar(
          content: Text('Payment Failed'),
        );
        ScaffoldMessenger.of(context).showSnackBar(failedSnackBar);
      },
      onCancel: () {
        const cancelSnackBar = SnackBar(
          content: Text('Payment Cancelled'),
        );
        ScaffoldMessenger.of(context).showSnackBar(cancelSnackBar);
      },
    );
  }

  final controller = Get.put(AcceptServices());

  getDtae() {
    DateTime dateTime = DateTime.now();
    print(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                onPressed();
              },
              child: const Text("get"),
            ),
          ],
        ),
      ),
    );
  }
}
