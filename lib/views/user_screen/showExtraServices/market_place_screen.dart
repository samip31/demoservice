// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/network/models/offer_model.dart';
import 'package:smartsewa/network/services/exraServices/market_controller.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/user_market_place/market_place_details_body.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/user_market_place/market_place_user_screen.dart';
import 'package:smartsewa/views/widgets/custom_dialogs.dart';

import '../../../network/base_client.dart';
import '../../../network/services/exraServices/offer_controller.dart';
import '../../serviceProviderScreen/extraServices/upload_secondhand.dart';
import '../../serviceProviderScreen/service_main_screen.dart';
import '../../widgets/custom_network_image.dart';
import '../../widgets/custom_text.dart';
import '../drawer screen/privacypolicyscreen.dart';
import '../main_screen.dart';

class MarketPlaceScreen extends StatefulWidget {
  final bool? isFromServiceScreen;
  final bool? isFromSearch;
  const MarketPlaceScreen({
    Key? key,
    this.isFromServiceScreen = false,
    this.isFromSearch = false,
  }) : super(key: key);

  @override
  State<MarketPlaceScreen> createState() => _SecondHandScreenState();
}

class _SecondHandScreenState extends State<MarketPlaceScreen> {
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
          : marketController.marketPlaceSearchData.value =
              marketController.marketPlaceResponseModel;
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
  String baseUrl = BaseClient().baseUrl;


  @override
  Widget build(BuildContext context) {
    // logger("widget.isFromServiceScreen :: ${widget.isFromServiceScreen}");
    return WillPopScope(
      onWillPop: () async {
        widget.isFromServiceScreen ?? false
            ? Get.offAll(() => const ServiceMainScreen())
            : widget.isFromSearch ?? false
                ? Get.off(() => const MarketPlaceScreen())
                : Get.offAll(() => const MainScreen());
        return true;
      },
      child: Scaffold(
        appBar: searchBar(context),
        drawer: widget.isFromSearch ?? false
            ? null
            : CustomDrawer(isFromServiceScreen: widget.isFromServiceScreen),
        drawerEdgeDragWidth: widget.isFromSearch ?? false ? 0 : 150,
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  if (marketController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      key: const PageStorageKey<String>("market_place_screen"),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: marketController.marketPlaceSearchData.length,
                      itemBuilder: (context, index) {
                        final market =
                            marketController.marketPlaceSearchData[index];
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
                                                maxLine: 1,
                                              ),
                                              vSizedBox0,
                                              buildRowContainer(
                                                title: "Brand:",
                                                message:
                                                    market.brand.toString(),
                                                maxLine: 1,
                                              ),
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
                                                    message:
                                                        market.price.toString(),
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
            InkWell(
              onTap: (){
                Get.to(()=> PrivacypolicyScreen());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.green)
                ),
                child: Row(
                  children: [
                    Flexible(child: Text('Note : Please Terms and Conditions carefully before you trade', style: TextStyle(fontWeight: FontWeight.w500),)),
                  ],
                ),
              ),
            ),
            // Image.asset(
            //   "assets/market_notes.jpg",
            //   fit: BoxFit.contain,
            // ),
            // Container(
            //   color: Colors.white,
            //   padding: screenPadding,
            //   child: CustomText.ourText(
            //     "Note: Please, Terms and conditions should be read carefully before you trade.",
            //     fontSize: 10,
            //     fontWeight: FontWeight.w400,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
        // bottomNavigationBar: BottomAppBar(
        //   color: Colors.black,
        //   child: SizedBox(
        //     height: 40,
        //     child: InkWell(
        //       onTap: () {
        //         widget.isFromServiceScreen ?? false
        //             ? Get.offAll(() => const ServiceMainScreen())
        //             : Get.offAll(() => const MainScreen());
        //       },
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Icon(
        //             Icons.home,
        //             size: 30,
        //             color: Theme.of(context).primaryColor,
        //           ),
        //           SizedBox(width: appWidth(context) * 0.02),
        //           Text(
        //             "Home",
        //             style: TextStyle(
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: 18,
        //                 color: Theme.of(context).primaryColor),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
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
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        hSizedBox0,
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
        "Market",
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
      //         marketController.marketPlaceSearchData.value =
      //             marketController.marketPlaceResponseModel.where((item) {
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
      //         marketController.marketPlaceSearchData.value =
      //             marketController.marketPlaceResponseModel;
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
                    isFromServiceScreen: widget.isFromServiceScreen,
                  );

                  // Debouncer(milliseconds: 100).run(() {
                  //   if (marketController.marketSearchController.text
                  //       .toString()
                  //       .isNotEmpty) {
                  //     marketController.marketPlaceSearchData.value =
                  //         marketController.marketPlaceResponseModel.where((item) {
                  //       return item.title.toString().toLowerCase().contains(
                  //           marketController.marketPlaceSearchData
                  //               .toString()
                  //               .toLowerCase());
                  //     }).toList();
                  //   } else {
                  //     marketController.marketPlaceSearchData.value =
                  //         marketController.marketPlaceResponseModel;
                  //   }
                  //   // consolelog(marketController.marketPlaceSearchData);
                  // });
                },
                icon: const Icon(Icons.search_outlined))
      ],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final bool? isFromServiceScreen;
  CustomDrawer({
    super.key,
    this.isFromServiceScreen,
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
                  Get.to(() => UploadSecondHand(
                        isFromServiceScreen: isFromServiceScreen,
                      ));
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
                  Get.to(() => MarketPlaceUserScreen(
                        isFromServiceScreen: isFromServiceScreen,
                      ));
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
              InkWell(
                onTap: () {
                  isFromServiceScreen ?? false
                      ? Get.offAll(() => const ServiceMainScreen())
                      : Get.offAll(() => const MainScreen());
                },
                child: const Card(
                  child: ListTile(
                    title: Text(
                      'Home',
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
