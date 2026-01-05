import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static void showSnackBar({
    String? title,
    Widget? icon,
    String? message,
    SnackPosition? snackPosition,
    SnackStyle? snackStyle,
    Color? color,
  }) {
    Get.snackbar(
      title ?? "",
      message ?? "",
      icon: icon,
      colorText: Colors.white,
      titleText: Text(
        title ?? "",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color ?? Colors.green,
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.vertical,
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      snackStyle: snackStyle ?? SnackStyle.FLOATING,
    );
  }
}
