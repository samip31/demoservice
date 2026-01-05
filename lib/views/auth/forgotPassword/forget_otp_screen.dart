import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';

import '../../../views/widgets/buttons/app_buttons.dart';
import '../otpField/otp_field.dart';
import 'change_password_forgetScreen.dart';

class ForgetOtpScreen extends StatefulWidget {
  int number;
  final String phone;
  ForgetOtpScreen({
    super.key,
    required this.number,
    required this.phone,
  });

  @override
  State<ForgetOtpScreen> createState() => _ForgetOtpScreenState();
}

class _ForgetOtpScreenState extends State<ForgetOtpScreen> {
  final authController = Get.put(AuthController());

  @override
  void dispose() {
    authController.otpController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.aspectRatio * 68),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.1),
              Image.asset(
                'assets/Logo.png',
                height: size.height * 0.2,
              ),
              SizedBox(height: size.height * 0.04),
              Text(
                "Enter your OTP sent to the number +977 ${widget.phone}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              OtpField(controller: authController.otpController),
              SizedBox(height: size.height * 0.07),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: size.height * 0.06,
                    width: size.width * 0.39,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          widget.number = Random().nextInt(90000) + 10000;
                          authController.sendOTP(
                              phoneNumber: widget.phone,
                              randomNumber: widget.number,
                              message:
                                  "your OTP verification code for forgot password is");
                        },
                        child: const Text(
                          'Resend',
                          style: TextStyle(
                            fontFamily: 'hello',
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Expanded(
                    child: AppButton(
                        name: 'Continue',
                        onPressed: () {
                          consolelog(
                              "${widget.number} :: ${authController.otpController.text}");
                          if (authController.otpController.text ==
                              widget.number.toString()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetChangePassword(
                                  mobileNumber: widget.phone,
                                ),
                              ),
                            );
                          } else {
                            errorToast(msg: "Otp didn't match");
                          }
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
