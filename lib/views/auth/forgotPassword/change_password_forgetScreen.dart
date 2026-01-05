// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartsewa/network/services/authServices/auth_controller.dart';

import '../../../views/widgets/buttons/app_buttons.dart';
import '../../widgets/custom_snackbar.dart';

class ForgetChangePassword extends StatefulWidget {
  final String? mobileNumber;
  const ForgetChangePassword({
    Key? key,
    this.mobileNumber,
  }) : super(key: key);

  @override
  State<ForgetChangePassword> createState() => _ForgetChangePasswordState();
}

class _ForgetChangePasswordState extends State<ForgetChangePassword> {
  final bool _oldPasswordvisible = false;
  bool _passwordvisible = false;
  bool _confirmpasswordvisible = false;

  AuthController authController = Get.put(AuthController());

  // final TextEditingController _oldPassword = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _confirmPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d)(?=.*?[!@#$&*~]).{8,}$');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(size.aspectRatio * 68),
          child: ListView(
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Image.asset(
                'assets/Logo.png',
                height: size.height * 0.2,
              ),
              SizedBox(height: size.height * 0.05),
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontFamily: 'hello',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.025),
              // Column(
              //   children: [
              //     const Row(
              //       children: [
              //         Icon(
              //           Icons.lock_open_rounded,
              //           size: 25,
              //           color: Colors.white70,
              //         ),
              //         SizedBox(width: 5),
              //         Text(
              //           'Old Password',
              //           style: TextStyle(
              //             fontFamily: 'hello',
              //             fontSize: 16,
              //             fontWeight: FontWeight.w500,
              //             color: Colors.white70,
              //           ),
              //         ),
              //       ],
              //     ),
              //     SizedBox(height: size.height * 0.012),
              //     TextFormField(
              //       autovalidateMode: AutovalidateMode.onUserInteraction,
              //       controller: _oldPassword,
              //       textAlign: TextAlign.left,
              //       style: const TextStyle(color: Colors.black),
              //       obscureText: !_oldPasswordvisible,
              //       validator: (oldPassword) {
              //         if (oldPassword!.isEmpty) {
              //           return 'Required**';
              //         }
              //         return null;
              //       },
              //       decoration: InputDecoration(
              //         suffixIcon: IconButton(
              //           onPressed: () {
              //             setState(() {
              //               _oldPasswordvisible = !_oldPasswordvisible;
              //             });
              //           },
              //           icon: Icon(_oldPasswordvisible
              //               ? CupertinoIcons.eye
              //               : CupertinoIcons.eye_slash),
              //         ),
              //         fillColor: Colors.white,
              //         filled: true,
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(18),
              //         ),
              //         hintText: '********',
              //         hintStyle: Theme.of(context).textTheme.titleLarge,
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: size.height * 0.025),
              Column(
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lock_open_rounded,
                        size: 25,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'hello',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.012),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _password,
                    validator: (password) {
                      if (password!.isEmpty) {
                        return 'Required**';
                      } else if (password.length < 8) {
                        return 'Password must contain atleast 8 characters';
                      }
                      return null;
                    },
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.black),
                    obscureText: !_passwordvisible,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordvisible = !_passwordvisible;
                              });
                            },
                            icon: Icon(_passwordvisible
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        hintText: '********',
                        hintStyle: Theme.of(context).textTheme.titleLarge),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.025),
              Column(
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lock_open_rounded,
                        size: 25,
                        color: Colors.white70,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontFamily: 'hello',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.012),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _confirmPassword,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.black),
                    obscureText: !_confirmpasswordvisible,
                    validator: (confirmPassword) {
                      if (confirmPassword!.isEmpty) {
                        return 'Required**';
                      } else if (confirmPassword != _password.text) {
                        return 'Password do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _confirmpasswordvisible =
                                  !_confirmpasswordvisible;
                            });
                          },
                          icon: Icon(
                            _confirmpasswordvisible
                                ? CupertinoIcons.eye
                                : CupertinoIcons.eye_slash,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        hintText: '********',
                        hintStyle: Theme.of(context).textTheme.titleLarge),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.04),
              Obx(
                () => authController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : AppButton(
                        name: 'Continue',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Get.to(() => const LoginScreen());
                            authController.forgotPassword(
                              confirmPassword: _confirmPassword.text.trim(),
                              newPassword: _password.text.trim(),
                              // oldPassword: _oldPassword.text.trim(),
                              mobileNumber: widget.mobileNumber,
                            );
                          } else {
                            CustomSnackBar.showSnackBar(
                                title: "Please fill", color: Colors.red);
                          }
                        },
                      ),
              ),
              SizedBox(height: size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
