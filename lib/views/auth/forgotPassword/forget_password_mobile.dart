import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../network/services/authServices/auth_controller.dart';
import '../../../views/widgets/buttons/app_buttons.dart';
import 'forget_otp_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();

  int randomNumber = 0;
  final TextEditingController phoneController = TextEditingController();
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(size.aspectRatio * 55),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.11),
                Column(
                  children: [
                    // SizedBox(height: size.height * 0.11),
                    Image.asset('assets/Logo.png', height: size.height * 0.15),
                    SizedBox(height: size.height * 0.05),
                    const Text(
                      "Enter your phone number to get verification code",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    Center(
                      child: TextFormField(
                        controller: phoneController,
                        validator: (password) {
                          if (password!.isEmpty || password.length != 10) {
                            return 'Enter a valid number';
                          }
                          if (!RegExp(r'^[9][7-8]\d{8}$').hasMatch(password)) {
                            return "Phone number not valid";
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'\d'),
                          ),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18)),
                            hintText: '98********',
                            hintStyle: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    AppButton(
                      name: 'Continue',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          randomNumber = Random().nextInt(90000) + 10000;
                          authController.sendOTP(
                              phoneNumber: phoneController.text,
                              randomNumber: randomNumber,
                              message:
                                  "your OTP verification code for forgot password is");
                          Get.to(() => ForgetOtpScreen(
                                number: randomNumber,
                                phone: phoneController.text,
                              ));
                        }
                      },
                    ),
                    // SizedBox(height: size.height * 0.2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
