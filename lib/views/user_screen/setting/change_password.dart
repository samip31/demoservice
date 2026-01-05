import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/network/services/userdetails/user_edit.dart';

import '../../widgets/my_appbar.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/textfield_box/passwordfield.dart';

class ChangePassword extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  ChangePassword({super.key});
  final userController = Get.put(UserEditController());
  final TextEditingController passwordcontroller1 = TextEditingController();
  final TextEditingController passwordcontroller3 = TextEditingController();
  final TextEditingController passwordcontroller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppbar(context, true, ""),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: EdgeInsets.all(size.aspectRatio * 30),
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.05),
              Image.asset(
                'assets/Logo.png',
                height: size.height * 0.2,
              ),
              SizedBox(height: size.height * 0.05),
              const Text(
                'Change Password',
                style: TextStyle(
                  fontFamily: 'hello',
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.025),
              currentPassword(context),
              SizedBox(height: size.height * 0.025),
              PasswordTextField(
                  name: 'New Password', controller: passwordcontroller1),
              SizedBox(height: size.height * 0.025),
              PasswordTextField(
                name: 'Confirm New Password',
                controller: passwordcontroller2,
              ),
              SizedBox(height: size.height * 0.04),
              AppButton(
                  name: 'Continue',
                  onPressed: () {
                    String newPassword = passwordcontroller1.text;
                    String confirmPassword = passwordcontroller2.text;
                    if (newPassword.isEmpty || confirmPassword.isEmpty) {
                      Get.snackbar("Error",
                          "New and Confirm New Password must not be empty",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red);
                    } else if (newPassword != confirmPassword) {
                      // Display error message or handle password mismatch error
                      Get.snackbar(
                          "Error", "New and Confirm New Password don't match",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red);
                    } else {
                      Get.dialog(AlertDialog(
                        title: const Text("Confirmation"),
                        content: const Text(
                            "Are you sure you want to change your password? You will be redirected to Login Screen"),
                        actions: [
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                              // Execute password change logic
                              userController.userChangePassword(
                                passwordcontroller3.text,
                                passwordcontroller1.text,
                                passwordcontroller2.text,
                              );
                            },
                          ),
                        ],
                      ));
                    }
                  }),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  currentPassword(context) {
    Size size = MediaQuery.of(context).size;

    return Column(
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
              'Current Password',
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
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black26),
              //  border: Border.all(color: Colors.white),
              color: Colors.white),
          height: size.height * 0.09,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: passwordcontroller3,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.black),
                obscureText: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '********',
                    hintStyle: Theme.of(context).textTheme.titleLarge),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
