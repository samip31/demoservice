import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/views/serviceProviderScreen/extraServices/upload_offer.dart';

import '../../../../core/dimension.dart';
import '../../../../network/services/exraServices/offer_controller.dart';
import '../../../../utils/debouncer.dart';
import '../../../widgets/custom_network_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../main_screen.dart';

class MyOfferScreen extends StatefulWidget {
  const MyOfferScreen({
    super.key,
  });

  @override
  State<MyOfferScreen> createState() => _MyOfferScreenState();
}

class _MyOfferScreenState extends State<MyOfferScreen> {
  final controller = Get.put(OfferController());
  String searchText = '';
  String? token;
  File? pickedOfferImage;

  bool isShowingSearchBar = false;

  @override
  void initState() {
    getToken();
    isShowingSearchBar = false;
    super.initState();
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    // int? tid = prefs.getInt("id");
    // setState(() {
    token = apptoken;
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        controller.fetchOffers();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: searchBar(context),
          drawer: CustomDrawer(),
          drawerEdgeDragWidth: 150,
          body: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.myOffersSearchData.isEmpty) {
                return Center(
                  child: CustomText.ourText("You haven't posted any offers."),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) => vSizedBox2,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.myOffersSearchData.length,
                  itemBuilder: (context, index) {
                    var item = controller.myOffersSearchData[index];
                    // return InkWell(
                    //   onTap: () {
                    //     // Get.to(() => WorkDetailScreen(
                    //     //       appTitle: widget.appTitle,
                    //     //       image: item.offerPicture,
                    //     //       title: item.title,
                    //     //       desc: item.addedDate,
                    //     //     ));
                    //   },
                    //   child: Card(
                    //     color: Colors.white12,
                    //     child: Row(
                    //       children: [
                    //         Image.network(
                    //             'http://13.232.92.169:9000/api/allimg/image/${item.offerPicture}',
                    //             headers: {
                    //               'Authorization': "Bearer $token",
                    //             },
                    //             width: size.width * 0.4,
                    //             fit: BoxFit.fill,
                    //             height: size.height * 0.2),
                    //         SizedBox(width: size.width * 0.05),
                    //         Expanded(
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(
                    //                 item.title.toString(),
                    //                 style: const TextStyle(
                    //                     fontSize: 18,
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.w500),
                    //               ),
                    //               SizedBox(height: size.height * 0.02),
                    //               // Text(
                    //               //   item.details.toString(),
                    //               //   maxLines: 3,
                    //               //   overflow: TextOverflow.ellipsis,
                    //               //   style: const TextStyle(
                    //               //       fontSize: 16,
                    //               //       color: Colors.white,
                    //               //       fontWeight: FontWeight.w500),
                    //               // ),
                    //             ],
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // );

                    return InkWell(
                      onTap: () {
                        // Get.to(() => VacancyDetailsBody(
                        //       title: vacancyItem.title,
                        //       vacancyId: vacancyItem.vacancyId,
                        //     ));
                      },
                      child: Padding(
                        padding: screenLeftRightPadding,
                        child: Card(
                          color: Colors.white12,
                          child: Column(
                            children: [
                              SizedBox(
                                width: appWidth(context),
                                height: appHeight(context) * 0.3,
                                child: item.offerPicture == null
                                    ? Image.asset(
                                        "assets/offer_sale.png",
                                        fit: BoxFit.cover,
                                        width: appWidth(context),
                                      )
                                    : customNetworkImage(
                                        pictureName: item.offerPicture,
                                        token: token,
                                      ),
                              ),
                              vSizedBox1,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText.ourText(
                                              "Added date:",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            hSizedBox0,
                                            Expanded(
                                              child: CustomText.ourText(
                                                "${item.addedDate}",
                                                fontSize: 15,
                                                color: Colors.grey.shade300,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        vSizedBox0,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText.ourText(
                                              "Expiration date:",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            hSizedBox0,
                                            Expanded(
                                              child: CustomText.ourText(
                                                "${item.expirationDate}",
                                                fontSize: 15,
                                                color: Colors.grey.shade300,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        vSizedBox1,
                                      ],
                                    ),
                                  ),
                                  hSizedBox1,
                                  // SizedBox(
                                  //   height: 35,
                                  //   child: TextButton(
                                  //     style: TextButton.styleFrom(
                                  //       shape: const RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.all(
                                  //           Radius.circular(4),
                                  //         ),
                                  //         side: BorderSide(
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //       padding: EdgeInsets.zero,
                                  //     ),
                                  //     onPressed: () {
                                  //       Get.to(() => UploadOffer(
                                  //             isFromEdit: true,
                                  //             offerEditId: item.offerId,
                                  //             offerTitle: item.title,
                                  //           ));
                                  //     },
                                  //     child: CustomText.ourText(
                                  //       "Edit",
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     SizedBox(
                          //       width: appWidth(context) * 0.4,
                          //       height: appHeight(context) * 0.2,
                          //       child: item.offerPicture == null
                          //           ? Image.asset(
                          //               "assets/offer_sale.png",
                          //               fit: BoxFit.cover,
                          //               width: appWidth(context) * 0.2,
                          //             )
                          //           : customNetworkImage(
                          //               pictureName: item.offerPicture,
                          //               token: token,
                          //             ),
                          //     ),
                          //     SizedBox(width: appWidth(context) * 0.03),
                          //     Expanded(
                          //       child: Padding(
                          //         padding: EdgeInsets.symmetric(
                          //           vertical: size.aspectRatio * 20.0,
                          //           horizontal: size.aspectRatio * 16,
                          //         ),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           children: [
                          //             buildRowContainer(
                          //               title: "Offer Id:",
                          //               message: item.offerId.toString(),
                          //             ),
                          //             vSizedBox0,
                          //             buildRowContainer(
                          //               title: "Title:",
                          //               message: item.title.toString(),
                          //             ),
                          //             vSizedBox0,
                          //             buildRowContainer(
                          //               title: "Added Date:",
                          //               message: DateFormat().format(
                          //                 item.addedDate ?? DateTime.now(),
                          //               ),
                          //             ),
                          //             vSizedBox0,
                          //             SizedBox(
                          //               height: 35,
                          //               child: AppButton(
                          //                 name: "Edit",
                          //                 onPressed: () {
                          //                   Get.to(() => UploadOffer(
                          //                         isFromEdit: true,
                          //                         offerEditId: item.offerId,
                          //                         offerTitle: item.title,
                          //                       ));
                          //                 },
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            child: SizedBox(
              height: 40,
              child: InkWell(
                onTap: () {
                  Get.offAll(() => const MainScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: appWidth(context) * 0.02),
                    Text(
                      "Home",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildRowContainer({String? title, String? message}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.ourText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        hSizedBox1,
        Expanded(
          child: CustomText.ourText(
            message ?? "",
            fontSize: 14,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
            maxLines: 5,
          ),
        ),
      ],
    );
  }

  AppBar searchBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xFF86E91A)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: isShowingSearchBar ? false : true,
      title: isShowingSearchBar
          ? CustomTextFormField(
              filled: true,
              fillColor: Colors.transparent,
              hintText: "Search...",
              textColor: Colors.white,
              controller: controller.offerSearchController,
              isFromSearch: true,
              textInputAction: TextInputAction.search,
              onChanged: (val) {
                // consolelog(val);
                Debouncer(milliseconds: 100).run(() {
                  if (val.toString().isNotEmpty) {
                    controller.myOffersSearchData.value =
                        controller.myOffersResponseModel.where((offer) {
                      return offer.category
                          .toString()
                          .toLowerCase()
                          .contains(val.toString().toLowerCase());
                    }).toList();
                  } else {
                    controller.myOffersSearchData.value =
                        controller.myOffersResponseModel;
                  }
                  // consolelog(vacancyController.vacancySearchData);
                });
              },
            )
          : CustomText.ourText(
              "Offer",
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isShowingSearchBar = !isShowingSearchBar;
              });
              // Debouncer(milliseconds: 100).run(() {
              //   if (controller.offerSearchController.text
              //       .toString()
              //       .isNotEmpty) {
              //     controller.myOffersSearchData.value =
              //         controller.myOffersResponseModel.where((offer) {
              //       return offer.category.toString().toLowerCase().contains(
              //           controller.offerSearchController.text
              //               .trim()
              //               .toLowerCase());
              //     }).toList();
              //   } else {
              //     controller.myOffersSearchData.value =
              //         controller.myOffersResponseModel;
              //   }
              //   // consolelog(controller.vacancySearchData);
              // });
            },
            icon: const Icon(Icons.search_outlined))
      ],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  CustomDrawer({
    super.key,
  });

  final controller = Get.put(OfferController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                // Get.to(() => const Payment(
                //       serviceType: "offer",
                //     ));
                Get.to(() => const UploadOffer());
              },
              child: const Card(
                child: ListTile(
                  title: Text(
                    'Add new post',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                controller.fetchMyOfferPost();
                Get.off(() => const MyOfferScreen());
              },
              child: const Card(
                child: ListTile(
                  title: Text(
                    'Watch your post',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class OfferCont extends GetxController {
//   var isLoading = false.obs;
//   var products = <OfferModel>[].obs;

//   @override
//   void onInit() {
//     getOffers();
//     super.onInit();
//   }

//   getOffers() async {
//     try {
//       isLoading.value = true;
//       final res = await http.get(
//         Uri.parse(
//             'https://raw.githubusercontent.com/sauravchaulagain/MovieApp/main/assets/movie.json'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//         },
//       );

//       if (res.statusCode == 200) {
//         final jsonList = json.decode(res.body);
//         products.assignAll(
//           (jsonList as List)
//               .map(
//                 (product) => OfferModel.fromJson(product),
//               )
//               .toList(),
//         );
//       } else {
//         throw Exception("Error loading data");
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
// }
