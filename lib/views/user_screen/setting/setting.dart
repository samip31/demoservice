import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/enum.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/views/widgets/buttons/app_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../network/services/contact_services/contact_controller.dart';
import '../../auth/login/login_screen.dart';
import '../../widgets/my_appbar.dart';
import '../profile/edit_profile_user.dart';
import 'change_password.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _controller = Get.put(ContactsController());
  bool switchValue1 = true;
  // bool switchValue2 = true;

  void logout() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // final token = await preferences.remove('token');
    // await preferences.remove('id');
    // if (token != null) {
    // } else {
    //   Get.offAll(() => const LoginScreen());
    // }

    // if (!switchValue2) {
    //   bool confirmed = await showConfirmationDialog();
    //   if (confirmed) {
    //     SharedPreferences preferences = await SharedPreferences.getInstance();
    //     await preferences.remove('token');
    //     await preferences.remove('id');
    //     Get.offAll(() => const LoginScreen());
    //   } else {
    //     setState(() {
    //       switchValue2 = true;
    //     });
    //   }
    // } else {
    //   SharedPreferences preferences = await SharedPreferences.getInstance();
    //   await preferences.remove('token');
    //   await preferences.remove('id');
    //   Get.offAll(() => const LoginScreen());
    // }
  }

  Future<bool> showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to disable auto-login?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when cancelled
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when confirmed
              },
            ),
          ],
        );
      },
    );
  }

  void openMail() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '${_controller.feedbackEmail}',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Feedback !!!',
      }),
    );
    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      log(e.toString());
    }
  }

  void openPlayStore() async {
    const String packageName = 'com.smartsewa.service';
    const String playStoreUrl =
        'https://play.google.com/store/apps/details?id=$packageName';
    const String message = playStoreUrl;
    const ClipboardData data = ClipboardData(text: playStoreUrl);
    await Clipboard.setData(data);

    try {
      // await launchUrlString('sms:?body=$message');
      await Share.share(message);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppbar(context, true, ""),
      body: Container(
        padding: EdgeInsets.all(size.aspectRatio * 50),
        width: double.infinity,
        decoration: const BoxDecoration(
            // borderRadius: BorderRadius.only(
            //   topRight: Radius.circular(30),
            //   topLeft: Radius.circular(30),
            // ),
            color: Colors.white),
        child: Column(
          children: [
            Text('Setting', style: Theme.of(context).textTheme.displayMedium),
            SizedBox(height: size.height * 0.03),

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileUser(),
                    ));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'hello',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Icon(CupertinoIcons.forward, color: Colors.black54),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(),
                    ));
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontFamily: 'hello',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Icon(CupertinoIcons.forward, color: Colors.black54),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notification',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black54),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                    activeColor: Theme.of(context).primaryColor,
                    value: switchValue1,
                    onChanged: (value) {
                      setState(() {
                        switchValue1 = !switchValue1;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Auto Login',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black54),
                ),
                ValueListenableBuilder(
                  valueListenable: selectedAutoLogin,
                  builder: (context, value, child) => Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      activeColor: Theme.of(context).primaryColor,
                      value: value ?? false,
                      onChanged: (val) async {
                        logger("rememberMe :: $val",
                            loggerType: LoggerType.success);
                        selectedAutoLogin.value = val;
                        var prefs = await SharedPreferences.getInstance();
                        await prefs.setBool("rememberMe", val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),

            InkWell(
              onTap: () {
                openMail();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Feedback',
                    style: TextStyle(
                      fontFamily: 'hello',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Icon(CupertinoIcons.forward, color: Colors.black54),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            InkWell(
              onTap: () {
                openPlayStore();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Share App',
                    style: TextStyle(
                      fontFamily: 'hello',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  Icon(CupertinoIcons.forward, color: Colors.black54),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.1),
            AppButton(
                name: "Logout",
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  log(preferences.getKeys().toList().toString());
                  await preferences.remove('token');
                  await preferences.remove('id');
                  await preferences.remove('workStatus');
                  await preferences.setBool('rememberMe', false);
                  var token = preferences.getString('token');
                  var id = preferences.getInt('id');
                  var workStatus = preferences.getInt('id');

                  consolelog('token is $token');
                  consolelog('id is $id');
                  consolelog('workStatus is $workStatus');
                  if (token != null) {
                  } else {
                    Get.offAll(() => const LoginScreen());
                  }
                  // Get.offAll(() => const LoginScreen());
                  // logout();
                })
            // SizedBox(height: size.height * 0.02),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'Random List',
            //       style: TextStyle(
            //           fontWeight: FontWeight.w500,
            //           fontSize: 20,
            //           color: Colors.black54),
            //     ),
            //     Transform.scale(
            //       scale: 0.7,
            //       child: CupertinoSwitch(
            //         activeColor: Colors.red,
            //         value: switchValue2,
            //         onChanged: (value) {
            //           setState(() {
            //             switchValue2 = !switchValue2;
            //           });
            //         },
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
