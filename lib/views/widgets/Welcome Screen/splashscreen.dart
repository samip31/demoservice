import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/network/services/orderService/request_service.dart';
import 'package:smartsewa/network/services/splash_controller.dart';
import 'package:smartsewa/views/widgets/Welcome%20Screen/permission_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final controller = Get.put(OrderController());
  final splashController = Get.put(SplashController());
  static const String keylogin = "login";

  @override
  void initState() {
    //final mytoken = prefs.setString('token', "abcd");
    splashController.checkScreen();
    // check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(size.aspectRatio * 180),
          child: Image.asset('assets/Logo.png'),
        ),
      ),
    );
  }

  check() async {
    Future.delayed(const Duration(seconds: 3), () async {
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PermissionScreen(
              token: "token",
            ),
          ));
    });
  }
}
