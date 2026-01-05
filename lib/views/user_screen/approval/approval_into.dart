// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import 'package:smartsewa/network/services/authServices/auth_controller.dart';
// import 'package:smartsewa/network/services/categories&services/categories_controller.dart';
// import 'package:smartsewa/views/user_screen/approval/approval_screen.dart';
// import '../../../network/base_client.dart';
// import '../../../network/models/servicemodel.dart';

// class ApprovalInto extends StatelessWidget {
//   final controller = Get.put(CatController());
//   final _controller = Get.put(AuthController());

//   ApprovalInto({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = PageController();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18.0),
//         child: PageView(
//           controller: controller,
//           children: [
//             firstPage(context),
//             secondPage(context),
//           ],
//         ),
//       ),
//       bottomSheet: Container(
//         color: Colors.white,
//         height: 60,
//         width: double.infinity,
//         child: TextButton(
//             onPressed: () {
//               Get.to(() => const ApprovalScreen());
//             },
//             child: const Text(
//               'Skip',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.red,
//               ),
//             )),
//       ),
//     );
//   }

//   final String baseUrl = BaseClient().baseUrl;

//   secondPage(context) {
//     return Column(
//       children: [
//         const SizedBox(height: 50),
//         const Text(
//           'Check your Categories',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Colors.black,
//           ),
//         ),
//         Expanded(
//             child: Obx(
//           () => GridView.builder(
//             itemCount: controller.products.length,
//             itemBuilder: (context, index) {
//               return InkWell(
//                 onTap: () {
//                   Future<List<ServicesList>> fetchServices() async {
//                     final res = await http.get(
//                       Uri.parse(
//                           '$baseUrl/api/category/${controller.products[index].categoryId}/services'),
//                       headers: <String, String>{
//                         'Content-Type': 'application/json',
//                         'Authorization': "Bearer ${_controller.token}"
//                       },
//                     );
//                     List myList = jsonDecode(res.body);
//                     return myList.map((e) => ServicesList.fromJson(e)).toList();
//                   }

//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return Dialog(
//                         backgroundColor: Colors.white,
//                         child: FutureBuilder(
//                             future: fetchServices(),
//                             builder: (context, snapshot) {
//                               if (snapshot.hasData) {
//                                 return ListView.builder(
//                                   itemCount: snapshot.data!.length,
//                                   itemBuilder: (context, index) {
//                                     return Card(
//                                       margin: const EdgeInsets.all(8),
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           side: BorderSide(
//                                               color: Theme.of(context)
//                                                   .primaryColor)),
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 20, horizontal: 10),
//                                         child: Text(
//                                           snapshot.data![index].name.toString(),
//                                           style: const TextStyle(
//                                             letterSpacing: 0.51,
//                                             fontFamily: 'hello',
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               } else {
//                                 return const Center(
//                                   child: CircularProgressIndicator(),
//                                 );
//                               }
//                             }),
//                       );
//                     },
//                   );
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(18),
//                       color: Colors.deepPurple),
//                   child: Center(
//                     child: Text(
//                       "${controller.products[index].categoryTitle}",
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black),
//                     ),
//                   ),
//                 ),
//               );
//             },
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: (1.3 / .4),
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10),
//           ),
//         )),
//         const SizedBox(height: 70),
//       ],
//     );
//   }

//   firstPage(context) {
//     Size size = MediaQuery.of(context).size;

//     return Column(
//       children: [
//         SizedBox(height: size.height * 0.1),
//         Image.asset('assets/6.png'),
//         const SizedBox(height: 20),
//         const Text(
//           'Welcome to Smart Sewa Service Provider',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue,
//           ),
//         ),
//         const SizedBox(height: 15),
//         const Text(
//           "Please Check Your service category",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         const Expanded(
//             child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Swipe ',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//               Icon(
//                 Icons.fast_forward,
//                 size: 30,
//               )
//             ],
//           ),
//         ))
//       ],
//     );
//   }
// }
