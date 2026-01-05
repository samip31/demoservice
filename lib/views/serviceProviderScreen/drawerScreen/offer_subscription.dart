// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smartsewa/views/serviceProviderScreen/bottomNavigation/billing.dart';
// import 'package:smartsewa/views/serviceProviderScreen/extraServices/upload_offer.dart';
// import 'package:smartsewa/views/serviceProviderScreen/extraServices/upload_secondhand.dart';
// import 'package:smartsewa/views/serviceProviderScreen/extraServices/upload_vaccancy.dart';
// import 'package:smartsewa/views/widgets/buttons/app_buttons.dart';

// import '../bottomNavigation/payment_screen_service.dart';

// class OfferSubscription extends StatefulWidget {
//   const OfferSubscription({Key? key, required this.extraService})
//       : super(key: key);

//   final extraService;

//   @override
//   State<OfferSubscription> createState() => _OfferSubscriptionState();
// }

// class _OfferSubscriptionState extends State<OfferSubscription> {
//   @override
//   Widget build(BuildContext context) {
//     final serivceType = widget.extraService;
//     Size size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//             vertical: size.aspectRatio * 30.0,
//             horizontal: size.aspectRatio * 40.0),
//         child: Column(
//           children: [
//             Text(
//               "Buy ${widget.extraService}",
//               style: const TextStyle(color: Colors.white, fontSize: 26),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: size.aspectRatio * 80, vertical: 20),
//               child: Text(
//                 "Buy subscriptions and get various services related to ${widget.extraService}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 " Our Plans",
//                 style: TextStyle(color: Colors.white, fontSize: 26),
//               ),
//             ),
//             SizedBox(height: size.height * 0.01),
//             SizedBox(
//               height: 290,
//               width: double.infinity,
//               child: ListView.builder(
//                 itemCount: items.length,
//                 itemBuilder: (context, index) {
//                   return buildBox(
//                     context,
//                     offerPlans[index].date,
//                     offerPlans[index].price,
//                     index,
//                   );
//                 },
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: AppButton(
//                     name: "Continue",
//                     onPressed: () {
//                       if (status == -1) {
//                         Get.snackbar("Error", "Please Select one plan",
//                             backgroundColor: Colors.red.shade200);
//                       } else if (status == 0) {
//                         Get.to(() => const PaymentScreenService());
//                         // Get.to(() => PaySubscription(
//                         //       name: namee,
//                         //       price: pricee,
//                         //       time: timee,
//                         //       page: pagee,
//                         //     ));
//                         // *************CHANGE TO REAL VALUE LATER****************
//                         // Get.to(() => PaymentScreenKhalti(
//                         //       paymentAmount: 10,
//                         //       serviceType: serivceType,
//                         //     ));
//                         // paymentAmount: 500
//                       } else if (status == 1) {
//                         Get.to(() => PaymentScreenKhalti(
//                               paymentAmount: 10,
//                               serviceType: serivceType,
//                             ));
//                         // paymentAmount: 1000
//                       } else {
//                         Get.to(() => PaymentScreenKhalti(
//                               paymentAmount: 10,
//                               serviceType: serivceType,
//                             ));
//                         // paymentAmount: 4000
//                       }
//                     }),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   int status = -1;
//   String namee = "a", timee = "b";
//   int pricee = 0;
//   Widget pagee = const UploadOffer();

//   buildContainer(
//       context, String name, int price, String time, int index, Widget page) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           status = index;
//           namee = name;
//           pricee = price;
//           timee = time;
//           pagee = page;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//             border: Border.all(
//                 color: status == index ? Colors.red : Colors.white, width: 3),
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12)),
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         height: 75,
//         width: double.infinity,
//         child: Row(
//           children: [
//             Text(
//               name,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   'Rs $price',
//                   style: const TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 21),
//                 ),
//                 Text(
//                   "$time Subscription",
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   buildBox(context, String date, int price, int index) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           namee = date;
//           status = index;
//           pricee = price;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: status == index ? Colors.red : Colors.white,
//             width: 3,
//           ),
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         padding: const EdgeInsets.all(10),
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         height: 75,
//         width: double.infinity,
//         child: Row(
//           children: [
//             Text(
//               date,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//             Text(
//               'Rs $price',
//               style: const TextStyle(
//                 color: Colors.red,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 21,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Subscripriton> items = [
//     Subscripriton(
//         name: "Offer", price: 1500, time: "Yearly", page: const UploadOffer()),
//     Subscripriton(
//         name: "Vaccancy",
//         price: 200,
//         time: "Daily",
//         page: const UploadVaccancy()),
//     Subscripriton(
//         name: "Second Hand",
//         price: 600,
//         time: "Monthly",
//         page: const UploadSecondHand()),
//   ];

//   List<Offer> offerPlans = [
//     Offer(date: '10 Days', price: 500),
//     Offer(date: '1 Month', price: 1500),
//     Offer(date: '3 Month', price: 4000),
//   ];
// }

// class Subscripriton {
//   final String name;
//   final String time;
//   final int price;
//   final Widget page;

//   Subscripriton(
//       {required this.name,
//       required this.time,
//       required this.price,
//       required this.page});
// }

// class Offer {
//   final String date;
//   final int price;

//   Offer({required this.date, required this.price});
// }
