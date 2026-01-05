import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/market_place_screen.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/offer.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/vacancy.dart';
import 'package:smartsewa/views/widgets/custom_text.dart';

class UploadServiceScreen extends StatelessWidget {
  const UploadServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: screenLeftRightPadding,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => const OfferScreen(
                    isFromServiceScreen: true,
                  ));
            },
            child: Container(
              padding: screenPadding,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/offer_sale.png",
                    height: 150,
                    width: 150,
                  ),
                  hSizedBox1,
                  CustomText.ourText("Offer"),
                ],
              ),
            ),
          ),
          vSizedBox2,
          InkWell(
            onTap: () {
              Get.to(() => const Vacancy(
                    isFromServiceScreen: true,
                  ));
            },
            child: Container(
              padding: screenPadding,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/vacancy.png",
                    height: 150,
                    width: 150,
                  ),
                  hSizedBox1,
                  CustomText.ourText("Vacancy"),
                ],
              ),
            ),
          ),
          vSizedBox2,
          InkWell(
            onTap: () {
              Get.to(() => const MarketPlaceScreen(
                    isFromServiceScreen: true,
                  ));
            },
            child: Container(
              padding: screenPadding,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/market.png",
                    height: 150,
                    width: 150,
                  ),
                  hSizedBox1,
                  CustomText.ourText("Market Place"),
                ],
              ),
            ),
          ),
          vSizedBox2,
        ],
      ),
    );
    // return DefaultTabController(
    //   length: 3,
    //   child: Column(
    //     children: [
    //       const TabBar(
    //         indicatorColor: Colors.greenAccent,
    //         tabs: [
    //           Tab(
    //             child: Text(
    //               "Offer",
    //               style: TextStyle(
    //                   fontSize: 18,
    //                   color: Colors.red,
    //                   fontWeight: FontWeight.w500),
    //             ),
    //           ),
    //           Tab(
    //             child: Text(
    //               "Vaccancy",
    //               style: TextStyle(
    //                   fontSize: 18,
    //                   color: Colors.red,
    //                   fontWeight: FontWeight.w500),
    //             ),
    //           ),
    //           Tab(
    //             child: FittedBox(
    //               child: Text(
    //                 "MarketPlace",
    //                 style: TextStyle(
    //                     fontSize: 18,
    //                     color: Colors.red,
    //                     fontWeight: FontWeight.w500),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Expanded(
    //         child: Padding(
    //           padding: EdgeInsets.all(size.aspectRatio * 28),
    //           child: const TabBarView(children: [
    //             // UploadOffer(),
    //             // UploadVaccancy(),
    //             // UploadSecondHand()
    //             OfferSubscription(
    //               extraService: 'offer',
    //             ),
    //             OfferSubscription(
    //               extraService: 'vacancy',
    //             ),
    //             OfferSubscription(
    //               extraService: 'marketplace',
    //             ),
    //           ]),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
