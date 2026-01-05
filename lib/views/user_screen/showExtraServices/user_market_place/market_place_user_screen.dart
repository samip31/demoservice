import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/network/models/offer_model.dart';
import 'package:smartsewa/network/services/exraServices/market_controller.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/market_place_screen.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/user_market_place/market_place_details_body.dart';

import '../../../../network/services/exraServices/offer_controller.dart';
import '../../../serviceProviderScreen/extraServices/upload_secondhand.dart';
import '../../../widgets/custom_dialogs.dart';
import '../../../widgets/custom_network_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/customalert.dart';
import '../../main_screen.dart';

class MarketPlaceUserScreen extends StatefulWidget {
  final bool? isFromSearch;
  final bool? isFromServiceScreen;
  const MarketPlaceUserScreen(
      {Key? key, this.isFromSearch = false, this.isFromServiceScreen = false})
      : super(key: key);

  @override
  State<MarketPlaceUserScreen> createState() => _SecondHandScreenState();
}

class _SecondHandScreenState extends State<MarketPlaceUserScreen> {
  final controller = Get.put(OfferController());
  final marketController = Get.put(MarketController());

  List mySecondHand = <OffersResponseModel>[].obs;
  String searchText = '';
  String? token;

  @override
  void initState() {
    getToken();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.isFromSearch ?? false
          ? null
          : marketController.myMarketPlaceSearchData.value =
              marketController.myMarketPlaceResponseModel;
    });
    // marketController.fetchMarkets();
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
    return WillPopScope(
      onWillPop: () async {
        widget.isFromSearch ?? false
            ? Get.off(() => MarketPlaceUserScreen(
                  isFromServiceScreen: widget.isFromServiceScreen,
                ))
            : [
                Get.off(() => MarketPlaceScreen(
                      isFromServiceScreen: widget.isFromServiceScreen,
                    )),
                marketController.fetchMarkets()
              ];
        return true;
      },
      child: Scaffold(
        appBar: searchBar(context),
        drawer: widget.isFromSearch ?? false ? null : CustomDrawer(),
        drawerEdgeDragWidth: widget.isFromSearch ?? false ? 0 : 150,
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  if (marketController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (marketController.myMarketPlaceSearchData.isEmpty) {
                    return Center(
                      child: CustomText.ourText("You donot have any post."),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          marketController.myMarketPlaceSearchData.length,
                      itemBuilder: (context, index) {
                        final market =
                            marketController.myMarketPlaceSearchData[index];
                        return InkWell(
                          onTap: () {
                            Get.to(() => MarketPlaceDetailsBody(
                                  marketId: market.marketId,
                                  title: market.title,
                                  token: token,
                                ));
                          },
                          child: Padding(
                            padding: screenLeftRightPadding,
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: appWidth(context) * 0.4,
                                          height: appHeight(context) * 0.195,
                                          child: market.marketpicture == null
                                              ? Image.asset(
                                                  "assets/market.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : customNetworkImage(
                                                  pictureName:
                                                      market.marketpicture,
                                                  token: token,
                                                ),
                                        ),
                                        vSizedBox1,
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          width: appWidth(context) * 0.4,
                                          height: 90,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Column(
                                            children: [
                                              buildRowContainer(
                                                title: "Title:",
                                                message:
                                                    market.title.toString(),
                                              ),
                                              vSizedBox0,
                                              buildRowContainer(
                                                title: "Brand:",
                                                message:
                                                    market.brand.toString(),
                                              ),
                                              vSizedBox0,
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            minHeight: 238),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(4),
                                              child: Column(
                                                children: [
                                                  buildRowContainer(
                                                    title: "Description:",
                                                    message: market.description
                                                        .toString(),
                                                  ),
                                                  vSizedBox0,
                                                  buildRowContainer(
                                                    title: "Price",
                                                    message: int.parse(market
                                                            .price
                                                            .toString())
                                                        .toString(),
                                                  ),
                                                  vSizedBox0,
                                                  buildRowContainer(
                                                    title: "Negotiable:",
                                                    message:
                                                        market.negotiable ??
                                                                false
                                                            ? "Yes"
                                                            : "No",
                                                  ),
                                                  vSizedBox0,
                                                  buildRowContainer(
                                                    title: "Condition:",
                                                    message: market.conditions
                                                        .toString(),
                                                  ),
                                                  vSizedBox0,
                                                  buildRowContainer(
                                                    title: "Warranty:",
                                                    message:
                                                        market.warranty == true
                                                            ? "Yes"
                                                            : "No",
                                                  ),
                                                  if (market.warranty ==
                                                      true) ...[
                                                    vSizedBox0,
                                                    buildRowContainer(
                                                      title: "Warranty Period:",
                                                      message:
                                                          "${market.warrantyPeriod == "" ? 0 : market.warrantyPeriod} months",
                                                    ),
                                                  ],
                                                  vSizedBox0,
                                                  buildRowContainer(
                                                    title: "Address:",
                                                    message: market.address
                                                        .toString(),
                                                  ),
                                                  vSizedBox0,
                                                  buildRowContainer(
                                                    title: "Contact:",
                                                    message: market.contactNo
                                                        .toString(),
                                                  ),
                                                  vSizedBox0,
                                                  buildRowContainer(
                                                    title: "Status:",
                                                    message:
                                                        market.sold ?? false
                                                            ? "Sold"
                                                            : "Available",
                                                  ),
                                                  vSizedBox0,
                                                ],
                                              ),
                                            ),
                                            vSizedBox0,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: SizedBox(
                                                    height: 35,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(4),
                                                          ),
                                                          side: BorderSide(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed:
                                                          market.sold ?? false
                                                              ? null
                                                              : () {
                                                                  MyDialogs().myAlert(
                                                                      context,
                                                                      "Edit",
                                                                      "Are you sure you want to update the sold status?",
                                                                      () {
                                                                    Get.back();
                                                                  }, () {
                                                                    Get.back();
                                                                    CustomDialogs.fullLoadingDialog(
                                                                        context:
                                                                            context,
                                                                        data:
                                                                            "Updating the sold status...");
                                                                    marketController
                                                                        .updateSoldStatusMarketPlace(
                                                                      marketId: market
                                                                          .marketId
                                                                          .toString(),
                                                                    );
                                                                  });
                                                                },
                                                      child: CustomText.ourText(
                                                        market.sold ?? false
                                                            ? "Already sold"
                                                            : "Sold",
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                market.sold == true
                                                    ? Container()
                                                    : Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: SizedBox(
                                                          height: 35,
                                                          child: TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          4),
                                                                ),
                                                                side:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                            onPressed: () {
                                                              Get.to(() =>
                                                                  UploadSecondHand(
                                                                    isFromEdit:
                                                                        true,
                                                                    market:
                                                                        market,
                                                                  ));
                                                            },
                                                            child: CustomText
                                                                .ourText(
                                                              "Edit",
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Image.asset(
              "assets/market_notes.png",
              fit: BoxFit.contain,
            ),
          ],
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
    );
  }

  buildRowContainer({String? title, String? message, int? maxLine}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.ourText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        hSizedBox1,
        Expanded(
          child: CustomText.ourText(
            message ?? "",
            fontSize: 15,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  AppBar searchBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xFF86E91A)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      automaticallyImplyLeading: true,
      title: CustomText.ourText(
        "My Market",
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).primaryColor,
      ),
      // title: CustomTextFormField(
      //   filled: true,
      //   fillColor: Colors.transparent,
      //   hintText: "Search...",
      //   textColor: Colors.white,
      //   controller: marketController.marketSearchController,
      //   isFromSearch: true,
      //   textInputAction: TextInputAction.search,
      //   onChanged: (val) {
      //     // consolelog(val);
      //     Debouncer(milliseconds: 100).run(() {
      //       if (val.toString().isNotEmpty) {
      //         marketController.myMarketPlaceSearchData.value =
      //             marketController.myMarketPlaceResponseModel.where((item) {
      //           return selectedFilterSearchValue.value == "Title"
      //               ? item.title
      //                   .toString()
      //                   .toLowerCase()
      //                   .contains(val.toString().toLowerCase())
      //               : item.brand
      //                   .toString()
      //                   .toLowerCase()
      //                   .contains(val.toString().toLowerCase());
      //         }).toList();
      //       } else {
      //         marketController.myMarketPlaceSearchData.value =
      //             marketController.myMarketPlaceResponseModel;
      //       }
      //       // consolelog(marketController.vacancySearchData);
      //     });
      //   },
      // ),
      actions: [
        // Container(
        //   padding: const EdgeInsets.all(8),
        //   width: 120,
        //   child: ValueListenableBuilder(
        //     valueListenable: selectedFilterSearchValue,
        //     builder: (context, value, child) => Container(
        //       // height: appHeight(context) * 0.0,
        //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(18),
        //         color: const Color(0xFF86E91A),
        //         border: Border.all(
        //           color: const Color(0xFF86E91A),
        //         ),
        //       ),
        //       child: DropdownButtonHideUnderline(
        //         child: DropdownButton(
        //             dropdownColor: const Color(0xFF86E91A),
        //             hint: const Text('Select'),
        //             isExpanded: true,
        //             menuMaxHeight: 800,
        //             value: value,
        //             items: ["Title", "Brand"]
        //                 .map(
        //                   (item) => DropdownMenuItem<String>(
        //                     value: item,
        //                     child: Text(
        //                       item.toString(),
        //                       style: const TextStyle(
        //                         color: Colors.black,
        //                       ),
        //                     ),
        //                   ),
        //                 )
        //                 .toList(),
        //             onChanged: (item) {
        //               selectedFilterSearchValue.value = item.toString();
        //             }),
        //       ),
        //     ),
        //   ),
        // ),
        widget.isFromSearch ?? false
            ? Container()
            : IconButton(
                onPressed: () {
                  CustomDialogs.filterSearchDialog(
                    context: context,
                    marketController: marketController,
                    isFromMyMarket: true,
                    isFromServiceScreen: widget.isFromServiceScreen,
                  );
                  // Debouncer(milliseconds: 100).run(() {
                  //   if (marketController.marketSearchController.text
                  //       .toString()
                  //       .isNotEmpty) {
                  //     marketController.myMarketPlaceSearchData.value =
                  //         marketController.myMarketPlaceResponseModel
                  //             .where((item) {
                  //       return item.title.toString().toLowerCase().contains(
                  //           marketController.myMarketPlaceSearchData
                  //               .toString()
                  //               .toLowerCase());
                  //     }).toList();
                  //   } else {
                  //     marketController.myMarketPlaceSearchData.value =
                  //         marketController.myMarketPlaceResponseModel;
                  //   }
                  // consolelog(marketController.myMarketPlaceSearchData);
                  // });
                },
                icon: const Icon(Icons.search_outlined),
              ),
      ],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  CustomDrawer({
    super.key,
  });

  final marketController = Get.put(MarketController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  // Get.to(() => const Payment(serviceType: "market"));
                  Get.to(() => const UploadSecondHand());
                },
                child: const Card(
                  child: ListTile(
                    title: Text(
                      'Add new post',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
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
                  marketController.fetchMyMarketsPost();
                  // Get.off(() => const UploadSecondHand());
                },
                child: const Card(
                  child: ListTile(
                    title: Text(
                      'Watch your post',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // const Card(
              //   child: ExpansionTile(
              //     title: Text(
              //       'Watch your post',
              //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              //     ),
              //     trailing: Icon(
              //       Icons.arrow_forward_ios_outlined,
              //       color: Colors.black,
              //     ),
              //     children: [
              //       ListTile(
              //         title: Text(
              //           'Edit your post',
              //           style: TextStyle(
              //               fontWeight: FontWeight.w500, fontSize: 16),
              //         ),
              //         // trailing: Icon(
              //         //   Icons.arrow_forward_ios_outlined,
              //         //   color: Colors.black,
              //         // ),
              //       ),
              //       ListTile(
              //         title: Text(
              //           'Delete your post',
              //           style: TextStyle(
              //               fontWeight: FontWeight.w500, fontSize: 16),
              //         ),
              //         // trailing: Icon(
              //         //   Icons.arrow_forward_ios_outlined,
              //         //   color: Colors.black,
              //         // ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
