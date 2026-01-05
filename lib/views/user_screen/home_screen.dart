// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:smartsewa/network/services/exraServices/offer_controller.dart';
// import 'package:smartsewa/views/user_screen/showExtraServices/offer.dart';
// import 'package:smartsewa/views/user_screen/showExtraServices/secondhand.dart';
// import 'package:smartsewa/views/user_screen/showExtraServices/vaccancy.dart';
// import '../../network/services/categories&services/categories_controller.dart';
// import 'categories/services.dart';

// class HomeScreen extends StatefulWidget {
//   final GlobalKey homeScreenKey;
  
//   const HomeScreen({
//     super.key,   required this.homeScreenKey,
//   });

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final int myTime = 3;

//   final List<String> images = [
//     ("assets/about.jpg"),
//     ("assets/indoorplant.jpg"),
//     ("assets/contact.jpg"),
//     ("assets/arrrowhead.jpg"),
//     ("assets/christmascactus.jpg"),
//   ];

//   final List<String> myImages = [
//     ("assets/services_images/electrical.png"),
//     ("assets/services_images/plumbing.png"),
//     ("assets/services_images/masonry_works.png"),
//     ("assets/services_images/cleaning.png"),
//     ("assets/services_images/carpentry.png"),
//     ("assets/services_images/metal_works.png"),
//     ("assets/services_images/paint_and_painting.png"),
//     ("assets/services_images/cook_and_waiter.png"),
//     ("assets/services_images/home_care_staff.png"),
//     ("assets/services_images/healthcare_and_medicine.png"),
//     ("assets/services_images/veterinary_and_pet_care.png"),
//     ("assets/services_images/tution_and_languages.png"),
//     ("assets/services_images/music_and_dance.png"),
//     ("assets/services_images/garderner_and_agriculture_works.png"),
//     ("assets/services_images/catering_and_rent.png"),
//     ("assets/services_images/event_and_party.png"),
//     ("assets/services_images/furniture_and_homedecor.png"),
//     ("assets/services_images/air_and_travels.png"),
//     ("assets/services_images/vehicle.png"),
//     ("assets/services_images/fitness_and_yoga.png"),
//     ("assets/services_images/waste_management.png"),
//     ("assets/services_images/trainning_and_skill_program.png"),
//     ("assets/services_images/office_staff.png"),
//     ("assets/services_images/advertisement_and_promotion.png"),
//     ("assets/services_images/printing_and_press.png"),
//     ("assets/services_images/books_and_stationery.png"),
//     ("assets/services_images/engineering.png"),
//     ("assets/services_images/others.png"),
//     ("assets/services_images/dharmik_karyakram.png"),
//   ];

//   // final List myIcons = [
//   //   Icons.electrical_services_rounded,
//   //   Icons.plumbing,
//   //   Icons.construction,
//   //   Icons.cleaning_services_outlined,
//   //   Icons.carpenter_outlined,
//   //   Icons.school_outlined,
//   //   Icons.format_paint_outlined,
//   //   Icons.agriculture_outlined,
//   //   Icons.health_and_safety_outlined,
//   //   Icons.pets,
//   //   Icons.fitness_center,
//   //   Icons.restaurant,
//   //   Icons.electrical_services_rounded,
//   //   Icons.plumbing,
//   //   Icons.construction,
//   //   Icons.cleaning_services_outlined,
//   //   Icons.carpenter_outlined,
//   //   Icons.school_outlined,
//   //   Icons.format_paint_outlined,
//   //   Icons.agriculture_outlined,
//   //   Icons.health_and_safety_outlined,
//   //   Icons.pets,
//   //   Icons.fitness_center,
//   //   Icons.restaurant,
//   //   Icons.pets,
//   //   Icons.fitness_center,
//   //   Icons.restaurant,
//   // ];

//   final controller = Get.put(CatController());
//   final ocontroller = Get.put(OfferController());

//   final scrollController = ScrollController();

//   // late String token;
//   @override
//   void initState() {
//     super.initState();
//     controller.getCategories();
//     // token = widget.token;
//     // log('homescreen $token');
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   void scrollUp() {
    
//     scrollController.animateTo(
//       0,
//       duration: const Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         // floatingActionButton: FloatingActionButton(
//         //   backgroundColor: Colors.black,
//         //   onPressed: scrollUp,
//         //   child: Icon(
//         //     Icons.arrow_upward,
//         //     color: Theme.of(context).primaryColor,
//         //   ),
//         // ),
//         body: Padding(
//       padding: EdgeInsets.symmetric(horizontal: size.aspectRatio * 40),
//       child: ListView(
//         controller: scrollController,
//         scrollDirection: Axis.vertical,
//         children: [
//           slider(context),
//           SizedBox(height: size.height * 0.01),
//           Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(size.aspectRatio * 12),
//               decoration: BoxDecoration(
//                   color: Colors.white12,
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(8)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   buildContainer(context, "Market", () {
//                     Get.to(
//                         () => const SecondHandScreen(appTitle: "Second Hand"));
//                   }, "assets/market.png"),
//                   buildContainer(context, "Vacancy", () {
//                     Get.to(() => const Vacancy(appTitle: "Vacancy"));
//                   }, 'assets/vacancy.png'),
//                   buildContainer(context, "Offer", () {
//                     Get.to(() => const OfferScreen(appTitle: "Offer/Sale"));
//                   }, 'assets/offer_sale.png'),
//                 ],
//               )),
//           SizedBox(height: size.height * 0.03),
//           const Text(
//             'Our Services',
//             style: TextStyle(
//               fontFamily: 'hello',
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//               color: Colors.white,
//             ),
//           ),
//           ConstrainedBox(
//             constraints: BoxConstraints(
//                 minHeight: size.height * 1.4, maxHeight: size.height * 1.48),
//             child: Container(
//                 padding: const EdgeInsets.only(
//                   top: 24,
//                 ),
//                 // height: size.height * 1.48,
//                 width: double.infinity,
//                 child: categories()),
//           ),
//           secondSlider(context),

//           // SizedBox(height: size.height * 0.03),
//         ],
//       ),
//     ));
//   }

//   buildContainer(context, String name, VoidCallback ontap, String image) {
//     Size size = MediaQuery.of(context).size;
//     return InkWell(
//       onTap: () {
//         ontap.call();
//       },
//       child: Column(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage(image), fit: BoxFit.cover),
//                 // color: Theme.of(context).primaryColor,
//                 borderRadius: BorderRadius.circular(10)
//                 // borderRadius: BorderRadius.circular(10000)
//                 ),
//             // child: Center(
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             //     children: [
//             //       const CircleAvatar(
//             //         backgroundColor: Colors.black,
//             //         backgroundImage: AssetImage('assets/market.png'),
//             //       ),
//             //       Text(
//             //         name,
//             //         style: const TextStyle(
//             //             color: Colors.black,
//             //             fontSize: 10,
//             //             fontWeight: FontWeight.w500),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           ),
//           SizedBox(
//             height: size.height * 0.01,
//           ),
//           Text(
//             name,
//             style: TextStyle(
//                 color: Theme.of(context).primaryColor,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   // categories() {
//   //   return GridView.builder(
//   //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //           crossAxisCount: 3, childAspectRatio: 0.13 / 0.12),
//   //       scrollDirection: Axis.vertical,
//   //       itemCount: myIcons.length,
//   //       itemBuilder: (context, index) {
//   //         return InkWell(
//   //           onTap: () {},
//   //           child: Column(
//   //             children: [
//   //               Icon(
//   //                 myIcons[index],
//   //                 size: 40,
//   //                 color: Theme.of(context).primaryColor,
//   //               ),
//   //               const SizedBox(height: 10),
//   //             ],
//   //           ),
//   //         );
//   //       });
//   // }
//   categories() {
//     return Obx(
//       () {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           return Row(
//             children: [
//               Expanded(
//                 child: GridView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 3,
//                             childAspectRatio: 0.16 / 0.12,
//                             crossAxisSpacing: 10,
//                             mainAxisSpacing: 20),
//                     scrollDirection: Axis.vertical,
//                     itemCount: controller.products.length,
//                     itemBuilder: (context, index) {
//                       final product = controller.products[index];
//                       return InkWell(
//                         onTap: () {
//                           Get.to(() => ServicesScreen(
//                                 name: product.categoryTitle.toString(),
//                                 id: product.categoryId.toString(),
//                               ));
//                         },
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: Image.asset(
//                                 myImages[index],
//                                 // fit: BoxFit.cover,
//                               ),
//                             ),
//                             // Icon(
//                             //   myIcons[index],
//                             //   size: 40,
//                             //   color: Theme.of(context).primaryColor,
//                             // ),
//                             const SizedBox(height: 10),
//                             Text(
//                               product.categoryTitle.toString(),
//                               textAlign: TextAlign.center,
//                               maxLines: 2,
//                               style: const TextStyle(
//                                 overflow: TextOverflow.ellipsis,
//                                 fontFamily: 'hello',
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                             )
//                           ],
//                         ),
//                       );
//                     }),
//               ),
//             ],
//           );
//         }
//       },
//     );
//   }

//   slider(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return CarouselSlider(
//       options: CarouselOptions(
//           aspectRatio: 16 / 9,
//           viewportFraction: 1.1,
//           autoPlayInterval: Duration(seconds: myTime),
//           height: size.height * 0.25,
//           enableInfiniteScroll: false,
//           autoPlay: true),
//       items: images
//           .map((e) => Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.asset(
//                     e,
//                     fit: BoxFit.cover,
//                   )
//                 ],
//               ))
//           .toList(),
//     );
//   }

//   secondSlider(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return CarouselSlider(
//       options: CarouselOptions(
//           aspectRatio: 1,
//           viewportFraction: 1,
//           autoPlayInterval: Duration(seconds: myTime),
//           height: size.height * 0.2,
//           enableInfiniteScroll: false,
//           autoPlay: true),
//       items: images
//           .map((e) => Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.asset(
//                     e,
//                     fit: BoxFit.cover,
//                   )
//                 ],
//               ))
//           .toList(),
//     );
//   }

//   final List<int> indexx = [7, 8, 9, 10, 11, 12];
// }
