import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

class PaySubscription extends StatelessWidget {
  final String name, time;
  final int price;
  final Widget page;

  const PaySubscription(
      {super.key,
      required this.name,
      required this.time,
      required this.price,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 36),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.white, fontSize: 36),
          ),
          Text(
            price.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 36),
          ),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() => page);
              },
              child: const Text(
                'Upload',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ))
        ],
      ),
    );
  }
}
