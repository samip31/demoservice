import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/views/auth/login/login_screen.dart';

import 'onboarding_screen.dart';

class PermissionScreen extends StatefulWidget {
  final String token;
  const PermissionScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _showAlert = false;
  final controller = Get.put(AuthController());

  @override
  void initState() {
    // requestPermission();
    _checkFirstLogin();
    super.initState();
  }

  _checkFirstLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLogin = prefs.getBool('first_login') ?? true;
    if (isFirstLogin) {
      setState(() {
        _showAlert = true;
      });
      await prefs.setBool('first_login', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showAlert) {
      return const OnBoardingScreen();
    }
    return const LoginScreen();
  }

  ///*******Permission For Location and Camera*******//////

  void requestPermission() async {
    // PermissionStatus cameraPermission = await Permission.camera.request();
    // if (!cameraPermission.isGranted) {
    // } else if (cameraPermission.isDenied) {
    //   Get.snackbar("Permission", "Please allow permission");
    // }
    // if (cameraPermission.isPermanentlyDenied) {
    //   openAppSettings();
    // }
    PermissionStatus locationPermission = await Permission.location.request();
    if (!locationPermission.isGranted) {
    } else if (locationPermission.isDenied) {
      Get.snackbar("Permission", "Please allow permission");
    }
    if (locationPermission.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
