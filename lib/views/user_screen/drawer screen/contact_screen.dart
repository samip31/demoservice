import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/network/services/contact_services/contact_controller.dart';

import '../../../network/services/userdetails/current_user_controller.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/my_appbar.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final controller = Get.put(CurrentUserController());
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final _controller = Get.put(ContactsController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldState,
        appBar: myAppbar(context, true, "Contact Us"),
        body: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.03),
                    // Center(
                    //     child: Text(
                    //   'This is contact us Page',
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .titleLarge!
                    //       .copyWith(fontSize: 26),
                    // )),
                    const Text(
                      'Smart Sewa Solutions Nepal Pvt. Ltd',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.1),

                    Text('Mobile no: ${_controller.contactUs}',
                        style: Theme.of(context).textTheme.titleMedium),

                    SizedBox(height: size.height * 0.02),
                    Text('Address: ${_controller.address}',
                        style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: size.height * 0.02),
                    Text('Email: ${_controller.email}',
                        style: Theme.of(context).textTheme.titleMedium),

                    SizedBox(height: size.height * 0.3),
                    AppButton(
                        name: "Back",
                        onPressed: () {
                          Get.back();
                        }),
                    SizedBox(height: size.height * 0.02),
                  ],
                ),
              ),
            );
          }
        }));
  }
}
