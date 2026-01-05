import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/views/widgets/custom_snackbar.dart';
import '../../../network/services/authServices/auth_controller.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../forgotPassword/forget_password_mobile.dart';
import '../registration/user_registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.put(AuthController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
              Image.asset('assets/Logo.png', height: size.height * 0.15),
              SizedBox(height: size.height * 0.01),
              phone(),
              SizedBox(height: size.height * 0.025),
              password(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Get.to(() => const ForgetPassword());
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(fontSize: 16),
                    )),
              ),
              Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return AppButton(
                    name: 'Log-in',
                    onPressed: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      log(preferences.getKeys().toList().toString());
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _controller.login(emailController, passwordController);
                      } else {
                        CustomSnackBar.showSnackBar(
                            title: "Please fill", color: Colors.red);
                      }
                    },
                  );
                }
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account?",
                    style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => UserRegistration());
                      },
                      child: const Text(
                        'Signup',
                        style: TextStyle(fontSize: 16),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }

  password() {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.lock_open_rounded,
              size: size.aspectRatio * 55,
              color: Colors.white,
            ),
            SizedBox(width: size.width * 0.02),
            const Text(
              'Password',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.012),
        TextFormField(
          controller: passwordController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Required**';
            }
            return null;
          },
          textAlign: TextAlign.left,
          obscureText: !isVisible,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                  isVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash),
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: '*********',
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }

  phone() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.phone,
              size: size.aspectRatio * 55,
              //size: 30,
              color: Colors.white,
            ),
            SizedBox(width: size.width * 0.02),
            const Text(
              'Phone',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.012),
        TextFormField(
          controller: emailController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Required**';
            }
            if (!RegExp(r'^[9][7-8]\d{8}$').hasMatch(value)) {
              return "Phone number not valid";
            }
            return null;
          },
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: '98********',
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
