import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/network/services/exraServices/market_controller.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

import '../../../../core/dimension.dart';
import '../../../widgets/buttons/app_buttons.dart';
import '../../../widgets/custom_snackbar.dart';

class MarketPlaceEditSold extends StatelessWidget {
  final String? marketId;
  MarketPlaceEditSold({super.key, this.marketId});

  final marketController = MarketController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, "Edit"),
      body: SingleChildScrollView(
        padding: screenLeftRightPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sold",
                  style: TextStyle(
                    fontFamily: 'hello',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                vSizedBox1,
                ValueListenableBuilder(
                  valueListenable: selectedSoldMarketPlace,
                  builder: (context, value, child) => Container(
                    width: double.infinity,
                    height: appHeight(context) * 0.07,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF889AAD),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          hint: const Text('Select'),
                          isExpanded: true,
                          menuMaxHeight: 800,
                          value: value,
                          items: ["Yes", "No"]
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
                            selectedSoldMarketPlace.value = item.toString();
                          }),
                    ),
                  ),
                ),
              ],
            ),
            vSizedBox2,
            Center(
              child: Padding(
                padding: EdgeInsets.all(size.aspectRatio * 75.0),
                child: Obx(
                  () => marketController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : AppButton(
                          name: "Submit",
                          onPressed: () {
                            if (selectedSoldMarketPlace.value != null) {
                              FocusScope.of(context).unfocus();
                              marketController.updateSoldStatusMarketPlace(
                                  marketId: marketId);
                            } else {
                              CustomSnackBar.showSnackBar(
                                title: "Please fill the fields",
                                color: Colors.red,
                              );
                            }
                          },
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
