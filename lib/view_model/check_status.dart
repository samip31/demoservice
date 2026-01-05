// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smartsewa/network/services/userdetails/current_user_controller.dart';
// import 'package:smartsewa/views/user_screen/main_screen.dart';
// import 'package:smartsewa/views/widgets/Welcome%20Screen/welcome_screen.dart';

// class CheckStatus extends StatefulWidget {
//   const CheckStatus({Key? key}) : super(key: key);

//   @override
//   State<CheckStatus> createState() => _CheckStatusState();
// }

// class _CheckStatusState extends State<CheckStatus> {
//   final controller = Get.put(CurrentUserController());
//   bool workStatus = false;

//   @override
//   void initState() {
//     super.initState();
//     controller.getCurrentUser();
//     check();
//   }

//   check() async {
//     var prefs = await SharedPreferences.getInstance();
//     workStatus = prefs.getBool("workStatus") ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("status is ${controller.workStatus}");
//     return Scaffold(
//       body: Obx(
//         () {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             return Container(
//               child: workStatus == true
//                   ? const WelcomeScreen()
//                   : const MainScreen(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
