import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smartsewa/network/services/exraServices/market_controller.dart';
import 'package:smartsewa/views/widgets/custom_network_image.dart';

import '../../../../core/dimension.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/my_appbar.dart';
import '../image_details_extraservice.dart';

class MarketPlaceDetailsBody extends StatefulWidget {
  final String? title;
  final int? marketId;
  final String? token;

  const MarketPlaceDetailsBody({
    super.key,
    this.marketId,
    this.title,
    this.token,
  });

  @override
  State<MarketPlaceDetailsBody> createState() => _MarketPlaceDetailsBodyState();
}

class _MarketPlaceDetailsBodyState extends State<MarketPlaceDetailsBody> {
  MarketController marketController = Get.put(MarketController());

  @override
  void initState() {
    super.initState();
    marketController.getInidividualMarketPlace(marketId: widget.marketId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar(context, true, "Market Place"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Obx(
          () => marketController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : marketController
                          .individualMarketPlaceResponseModel.value.marketId ==
                      null
                  ? const Center(
                      child: Text(
                        "Error fetching details",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: [
                        vSizedBox0,
                        GestureDetector(
                          onTap: () {
                            Get.to(() => ImageDetailsExtraService(
                                  image: marketController
                                      .individualMarketPlaceResponseModel
                                      .value
                                      .marketpicture,
                                  token: widget.token,
                                  title: "Market",
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 250,
                                  maxHeight: 250,
                                ),
                                child: marketController
                                            .individualMarketPlaceResponseModel
                                            .value
                                            .marketpicture ==
                                        null
                                    ? Image.asset(
                                        "assets/market.png",
                                        fit: BoxFit.contain,
                                      )
                                    : customNetworkImage(
                                        pictureName: marketController
                                            .individualMarketPlaceResponseModel
                                            .value
                                            .marketpicture,
                                        token: widget.token,
                                        boxFit: BoxFit.contain,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        vSizedBox3,
                        buildMarketRowInformation(
                          title: "Title:",
                          value: marketController
                              .individualMarketPlaceResponseModel.value.title
                              .toString(),
                        ),
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Brand:",
                          value: marketController
                                  .individualMarketPlaceResponseModel
                                  .value
                                  .brand ??
                              "",
                        ),
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Description:",
                          value: marketController
                                  .individualMarketPlaceResponseModel
                                  .value
                                  .description ??
                              "",
                        ),
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Price:",
                          value: marketController
                              .individualMarketPlaceResponseModel.value.price
                              .toString(),
                        ),
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Negotiable:",
                          value: marketController
                                      .individualMarketPlaceResponseModel
                                      .value
                                      .negotiable ??
                                  false
                              ? "Yes"
                              : "No",
                        ),
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Condition:",
                          value: marketController
                                  .individualMarketPlaceResponseModel
                                  .value
                                  .conditions ??
                              "",
                        ),
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Warranty:",
                          value: marketController
                                      .individualMarketPlaceResponseModel
                                      .value
                                      .warranty ??
                                  false
                              ? "Yes"
                              : "No",
                        ),
                        if (marketController.individualMarketPlaceResponseModel
                                .value.warranty ??
                            false) ...[
                          vSizedBox1,
                          buildMarketRowInformation(
                            title: "Warranty Period:",
                            value:
                                "${marketController.individualMarketPlaceResponseModel.value.warrantyPeriod == "" ? 0 : marketController.individualMarketPlaceResponseModel.value.warrantyPeriod} months",
                          ),
                        ],
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Delivery:",
                          value: marketController
                                      .individualMarketPlaceResponseModel
                                      .value
                                      .delivery ??
                                  false
                              ? "Yes"
                              : "No",
                        ),
                        if (marketController.individualMarketPlaceResponseModel
                                .value.delivery ??
                            false) ...[
                          vSizedBox1,
                          buildMarketRowInformation(
                            title: "Delivery Charge:",
                            value: marketController
                                .individualMarketPlaceResponseModel
                                .value
                                .deliveryCharge
                                .toString(),
                          ),
                        ],
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Posted By:",
                          value: marketController
                                  .individualMarketPlaceResponseModel
                                  .value
                                  .contactPerson ??
                              "",
                        ),
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Contact Number:",
                          value: marketController
                              .individualMarketPlaceResponseModel
                              .value
                              .contactNo
                              .toString(),
                        ),
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Address:",
                          value: marketController
                                  .individualMarketPlaceResponseModel
                                  .value
                                  .address ??
                              "",
                        ),
                        vSizedBox1,
                        buildMarketRowInformation(
                          title: "Expired Date:",
                          value: DateFormat().format(
                            marketController.individualMarketPlaceResponseModel
                                    .value.expirationDate ??
                                DateTime.now(),
                          ),
                        ),
                        vSizedBox2,
                        // const Divider(
                        //   color: Colors.grey,
                        //   height: 5,
                        // ),
                      ],
                    ),
        ),
      ),
    );
  }
}

Widget buildMarketRowInformation({String? title, String? value}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomText.ourText(
        title,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      hSizedBox1,
      Expanded(
        child: CustomText.ourText(
          value ?? "",
          fontSize: 16,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
          isMaxLine: false,
        ),
      ),
    ],
  );
}
