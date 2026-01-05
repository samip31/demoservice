import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/views/widgets/buttons/app_buttons.dart';
import 'package:smartsewa/views/widgets/custom_dialogs.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';
import '../../../network/services/authServices/auth_controller.dart';
import '../../widgets/custom_toasts.dart';
import '../otpField/otp_field.dart';

class RegisterOtp extends StatefulWidget {
  final int number;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;

  final String latitude;
  final String longitude;

  const RegisterOtp(
      {super.key,
      required this.number,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.phone,
      required this.latitude,
      required this.longitude});

  @override
  State<RegisterOtp> createState() => _RegisterOtpState();
}

class _RegisterOtpState extends State<RegisterOtp> {
  verify() {
    var myOtp = otp.text;
    if (widget.number.toString() == myOtp) {
      CustomDialogs.fullLoadingDialog(
          context: context, data: "Registering, Please wait...");
      controller.registerUser(widget.firstName, widget.lastName, widget.phone,
          widget.email, widget.password, widget.latitude, widget.longitude);
    } else {
      errorToast(msg: "Otp didn't match");
    }
  }

  final controller = Get.put(AuthController());

  final otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppbar(context, true, "OTP"),
      body: Padding(
        padding: EdgeInsets.all(size.aspectRatio * 68),
        child: ListView(
          children: [
            SizedBox(height: size.height * 0.1),
            Image.asset('assets/Logo.png', height: size.height * 0.15),
            SizedBox(height: size.height * 0.05),
            Text(
              "Enter your OTP sent to the number ${widget.phone}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            SizedBox(height: size.height * 0.04),
            OtpField(controller: otp),
            SizedBox(height: size.height * 0.07),
            AppButton(
                name: 'Verify',
                onPressed: () {
                  verify();
                }),
            // Expanded(
            //   child: Center(
            //     child: Image.asset(
            //       'assets/Logo.png',
            //       height: size.height * 0.2,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
