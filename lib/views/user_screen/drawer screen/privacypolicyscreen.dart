import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/views/widgets/buttons/app_buttons.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

class PrivacypolicyScreen extends StatelessWidget {
  const PrivacypolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, "Terms & Condition"),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // app name
                const Text(
                  'Smart Sewa Solutions Nepal Pvt. Ltd',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),

                SizedBox(height: size.height * 0.02),

                // description
                const Text(
                  'Please read the following disclaimer carefully before using Smart Sewa App operated by Smart Sewa '
                  'Solutions Nepal Pvt. Ltd. Your access and use of the Service are subject to your acceptance and '
                  'compliance with these Terms. These Terms apply to all users, visitors, and anyone else who uses or '
                  'accesses the service. If you do not agree to any part of these terms, you may not access or use the '
                  'service. Please note that these Terms of Service serve as a general agreement for accessing and using the '
                  'Smart Sewa app and services. ',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                const Text(
                  'Disclaimer',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.015),

                // disclaimer
                const Text(
                  'Our mobile application acts as a third party between service providers and service receivers. We do not'
                  'provide any services ourselves and only act as a mediator to connect service providers and service '
                  'receivers. We do not endorse any service provider or service receiver and do not guarantee the quality '
                  'or safety of any services provided. However, we will handle the compliance and allow to rate the genuine '
                  'service providers. In case of misconduct, we can disqualify any user for providing service via Smart Sewa '
                  'application which is sole right of our company. '
                  'By using our mobile application, you acknowledge and agree that we are not responsible for any '
                  'interactions or transactions between service providers and service receivers. Any financial disputes or '
                  'other issues that may arise between service providers and service receivers are solely between those '
                  'parties and are not the responsibility as well as liability of our company. ',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: size.height * 0.015),

                // disclaimer
                const Text(
                  'We are not liable for any loss or damage that may occur as a result of using our mobile application or any '
                  'services provided by service providers. Our company is not responsible for any legal or financial liability '
                  'that may arise from interactions or transactions between service providers and service receivers. '
                  'By using our mobile application, you agree to release our company from any and all claims, damages, or '
                  'disputes that may arise from interactions or transactions between service providers and service '
                  'receivers. You agree to use our mobile application at your own risk and assume all responsibility for any '
                  'consequences that may arise. '
                  'In case of disputes, depending on its nature the governing rules and laws of Nepal will prevail to settle '
                  'the disputes. ',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                AppButton(
                    name: "Back",
                    onPressed: () {
                      Get.back();
                    }),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
