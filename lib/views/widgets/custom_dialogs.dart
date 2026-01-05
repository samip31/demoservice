import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/core/route_navigation.dart';
import 'package:smartsewa/network/services/exraServices/market_controller.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/market_place_screen.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/user_market_place/market_place_user_screen.dart';

import '../../core/dimension.dart';
import '../../core/states.dart';
import 'custom_text_form_field.dart';

class CustomDialogs {
  static fullLoadingDialog({String? data, required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xff141A31).withOpacity(0.3),
      barrierLabel: data ?? "Loading...",
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.2),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      valueColor: AlwaysStoppedAnimation(Color(0xFF86E91A)),
                    ),
                  ),
                  vSizedBox0,
                  Text(
                    data ?? "Loading...",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static filterSearchDialog({
    String? data,
    required BuildContext context,
    required MarketController marketController,
    bool? isFromMyMarket = false,
    bool? isFromServiceScreen = false,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Container(
            padding: screenPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: appWidth(context),
                  child: ValueListenableBuilder(
                    valueListenable: selectedFilterSearchValue,
                    builder: (context, value, child) => Container(
                      // height: appHeight(context) * 0.0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        // color: const Color(0xFF86E91A),
                        border: Border.all(
                          color: const Color(0xFF86E91A),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            // dropdownColor: const Color(0xFF86E91A),
                            hint: const Text('Select'),
                            isExpanded: true,
                            menuMaxHeight: 800,
                            value: value,
                            items: ["Title", "Brand"]
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (item) {
                              selectedFilterSearchValue.value = item.toString();
                            }),
                      ),
                    ),
                  ),
                ),
                vSizedBox2,
                CustomTextFormField(
                  hintText: "Search...",
                  textColor: Colors.black,
                  controller: marketController.marketSearchController,
                  isFromSearch: true,
                  textInputAction: TextInputAction.search,
                  onChanged: (val) {},
                ),
                vSizedBox2,
                SizedBox(
                  width: appWidth(context),
                  height: 44,
                  child: TextButton(
                    onPressed: () {
                      if (isFromMyMarket == false) {
                        if (marketController.marketSearchController.text
                            .toString()
                            .isNotEmpty) {
                          marketController.marketPlaceSearchData.value =
                              marketController.marketPlaceResponseModel
                                  .where((item) {
                            return selectedFilterSearchValue.value == "Title"
                                ? item.title.toString().toLowerCase().contains(
                                    marketController.marketSearchController.text
                                        .toString()
                                        .toLowerCase())
                                : item.brand.toString().toLowerCase().contains(
                                    marketController.marketSearchController.text
                                        .toString()
                                        .toLowerCase());
                          }).toList();
                        } else {
                          marketController.marketPlaceSearchData.value =
                              marketController.marketPlaceResponseModel;
                        }
                      } else {
                        if (marketController.marketSearchController.text
                            .toString()
                            .isNotEmpty) {
                          marketController.myMarketPlaceSearchData.value =
                              marketController.myMarketPlaceResponseModel
                                  .where((item) {
                            return selectedFilterSearchValue.value == "Title"
                                ? item.title.toString().toLowerCase().contains(
                                    marketController.marketSearchController.text
                                        .toString()
                                        .toLowerCase())
                                : item.brand.toString().toLowerCase().contains(
                                    marketController.marketSearchController.text
                                        .toString()
                                        .toLowerCase());
                          }).toList();
                        } else {
                          marketController.myMarketPlaceSearchData.value =
                              marketController.myMarketPlaceResponseModel;
                        }
                      }
                      Get.back();
                      if (marketController
                          .marketSearchController.text.isNotEmpty) {
                        isFromMyMarket ?? false
                            ? navigate(
                                context,
                                MarketPlaceUserScreen(
                                  isFromSearch: true,
                                  isFromServiceScreen: isFromServiceScreen,
                                ))
                            : navigate(
                                context,
                                MarketPlaceScreen(
                                  isFromSearch: true,
                                  isFromServiceScreen: isFromServiceScreen,
                                ));
                      }
                    },
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
