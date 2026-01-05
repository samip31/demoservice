import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/network/services/userdetails/current_user_controller.dart';
import 'package:smartsewa/views/serviceProviderScreen/service_main_screen.dart';
import 'package:smartsewa/views/user_screen/main_screen.dart';
import '../buttons/app_buttons.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = Get.put(AuthController());
  final userController = Get.put(CurrentUserController());

  // bool _showAlert = false;
  //
  @override
  void initState() {
    super.initState();
    userController.getCurrentUser();
    // _checkFirstLogin();
  }
  //
  // Future<void> _checkFirstLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isFirstLogin = prefs.getBool('firstlogin') ?? true;
  //   if (isFirstLogin) {
  //     setState(() {
  //       _showAlert = true;
  //     });
  //     await prefs.setBool('firstlogin', false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.png',
              height: size.height * 0.25,
            ),
            SizedBox(height: size.height * 0.05),
            const Text(
              'Welcome to Smart Sewa \nSolutions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'hello',
                fontSize: 23,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            const Text(
              'Login Type?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white54,
              ),
            ),
            SizedBox(height: size.height * 0.005),
            AppButton(
                name: "User",
                onPressed: () {
                  Get.to(() => const MainScreen());
                }),
            SizedBox(height: size.height * 0.04),
            AppButton(
                name: 'Service Provider',
                onPressed: () {
                  Get.to(() => const ServiceMainScreen());
                }),
          ],
        ),
      ),
    );
  }

  buildAlert() {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        vertical: size.aspectRatio * 520,
        horizontal: size.aspectRatio * 60,
      ),
      child: Column(
        children: [
          Container(
            height: size.height * 0.15,
            color: Colors.greenAccent,
            child: const Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.aspectRatio * 18),
            child: Column(
              children: [
                const Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.012),
                const Text(
                  'You have been accepted as a service provider'
                  '. Please Login as a service provider.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'hello',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 38, vertical: 8),
                      child: const Text(
                        'Ok',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.to(() => const ServiceMainScreen());
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
