import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/core/route_navigation.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/network/models/market_model.dart';
import 'package:smartsewa/network/services/exraServices/market_controller.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import '../../../core/development/console.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/my_appbar.dart';

class UploadSecondHand extends StatefulWidget {
  final bool? isFromServiceScreen;
  final bool? isFromEdit;
  final MarketPlaceResponseModel? market;
  const UploadSecondHand(
      {Key? key, this.isFromServiceScreen, this.isFromEdit, this.market})
      : super(key: key);

  @override
  State<UploadSecondHand> createState() => _UploadSecondHandState();
}

class _UploadSecondHandState extends State<UploadSecondHand> {
  final marketController = Get.put(MarketController());

  File? pickedMarketImage;

  List<String> boolList = [
    "Yes",
    "No",
  ];
  List<String> itemConditionStatus = [
    "New",
    "Used",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.market != null) {
      marketController.marketTitleController.text = widget.market?.title ?? "";
      marketController.marketAddressController.text =
          widget.market?.address ?? "";
      marketController.marketBrandController.text = widget.market?.brand ?? "";
      marketController.marketContactNoController.text =
          widget.market?.contactNo.toString() ?? "";
      marketController.marketContactPersonController.text =
          widget.market?.contactPerson ?? "";
      selectedDeliveryMarketPlace.value =
          widget.market?.delivery ?? false ? "Yes" : "No";
      if (widget.market?.conditions != null) {
        selectedItemConditionMarketPlace.value =
            widget.market?.conditions.toString();
      }
      if (widget.market?.negotiable != null) {
        selectedNegotiableMarketPlace.value =
            widget.market?.negotiable ?? false ? "Yes" : "No";
      }
      selectedWarrantyMarketPlace.value =
          widget.market?.delivery ?? false ? "Yes" : "No";
      marketController.marketPriceController.text =
          widget.market?.price.toString() ?? "";
      if (widget.market?.deliveryCharge != null) {
        marketController.marketDeliveryChargeController.text =
            widget.market?.deliveryCharge.toString() ?? "";
      }
      marketController.marketDescriptionController.text =
          widget.market?.description ?? "";
      if (widget.market?.warrantyPeriod != null) {
        marketController.marketWarrantyPeriodController.text =
            widget.market?.warrantyPeriod.toString() ?? "";
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        marketController.clearValue();
        selectedDeliveryMarketPlace.value = null;
        selectedNegotiableMarketPlace.value = null;
        selectedWarrantyMarketPlace.value = null;
        return true;
      },
      child: Scaffold(
        appBar: myAppbar(context, true, "Add New Post"),
        body: Padding(
          padding: screenLeftRightPadding,
          child: Form(
            key: marketController.marketFormState,
            child: ListView(
              children: [
                vSizedBox1,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Title",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    CustomTextFormField(
                      hintText: "Title",
                      controller: marketController.marketTitleController,
                      textInputType: TextInputType.text,
                      filled: true,
                      fillColor: Colors.white,
                      validator: (val) =>
                          val.toString().isEmpty ? "Cannot be empty" : null,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Brand",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    CustomTextFormField(
                      hintText: "Brand",
                      controller: marketController.marketBrandController,
                      textInputType: TextInputType.text,
                      filled: true,
                      fillColor: Colors.white,
                      validator: (val) =>
                          val.toString().isEmpty ? "Cannot be empty" : null,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    CustomTextFormField(
                      hintText: "Description",
                      controller: marketController.marketDescriptionController,
                      textInputType: TextInputType.text,
                      filled: true,
                      fillColor: Colors.white,
                      validator: (val) =>
                          val.toString().isEmpty ? "Cannot be empty" : null,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Price",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    CustomTextFormField(
                      hintText: "Price",
                      controller: marketController.marketPriceController,
                      textInputType: TextInputType.number,
                      filled: true,
                      fillColor: Colors.white,
                      validator: (val) =>
                          val.toString().isEmpty ? "Cannot be empty" : null,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Condition",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    ValueListenableBuilder(
                      valueListenable: selectedItemConditionMarketPlace,
                      builder: (context, value, child) => Container(
                        width: double.infinity,
                        height: size.height * 0.07,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF889AAD),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: const Text('Select condition'),
                              isExpanded: true,
                              menuMaxHeight: 800,
                              value: value,
                              items: itemConditionStatus
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
                                selectedItemConditionMarketPlace.value =
                                    item.toString();
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Negotiable",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    ValueListenableBuilder(
                      valueListenable: selectedNegotiableMarketPlace,
                      builder: (context, value, child) => Container(
                        width: double.infinity,
                        height: size.height * 0.07,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF889AAD),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: const Text('Select negotiable'),
                              isExpanded: true,
                              menuMaxHeight: 800,
                              value: value,
                              items: boolList
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
                                selectedNegotiableMarketPlace.value =
                                    item.toString();
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Warranty",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    ValueListenableBuilder(
                      valueListenable: selectedWarrantyMarketPlace,
                      builder: (context, value, child) => Container(
                        width: double.infinity,
                        height: size.height * 0.07,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF889AAD),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: const Text('Select warranty'),
                              isExpanded: true,
                              menuMaxHeight: 800,
                              value: value,
                              items: boolList
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
                                selectedWarrantyMarketPlace.value =
                                    item.toString();
                                item == "No"
                                    ? marketController
                                        .marketWarrantyPeriodController
                                        .text = ""
                                    : null;
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Warranty Period",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    ValueListenableBuilder(
                      valueListenable: selectedWarrantyMarketPlace,
                      builder: (context, value, index) => CustomTextFormField(
                        hintText: "5 (in months)",
                        controller:
                            marketController.marketWarrantyPeriodController,
                        textInputType: TextInputType.number,
                        readOnly:
                            value == null || value == "Yes" ? false : true,
                        filled: true,
                        fillColor: Colors.white,
                        validator: (val) => value == null || value == "Yes"
                            ? val.toString().isEmpty
                                ? "Cannot be empty"
                                : null
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    ValueListenableBuilder(
                      valueListenable: selectedDeliveryMarketPlace,
                      builder: (context, value, child) => Container(
                        width: double.infinity,
                        height: size.height * 0.07,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF889AAD),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              hint: const Text('Select delivery'),
                              isExpanded: true,
                              menuMaxHeight: 800,
                              value: value,
                              items: boolList
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
                                selectedDeliveryMarketPlace.value =
                                    item.toString();
                                item == "No"
                                    ? marketController
                                        .marketDeliveryChargeController
                                        .text = ""
                                    : null;
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Charge",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    ValueListenableBuilder(
                      valueListenable: selectedDeliveryMarketPlace,
                      builder: (context, value, index) => CustomTextFormField(
                        hintText: "Delivery Charge",
                        controller:
                            marketController.marketDeliveryChargeController,
                        textInputType: TextInputType.number,
                        filled: true,
                        readOnly:
                            value == null || value == "Yes" ? false : true,
                        fillColor: Colors.white,
                        validator: (val) => value == null || value == "Yes"
                            ? val.toString().isEmpty
                                ? "Cannot be empty"
                                : null
                            : null,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ],
                ),
                // vSizedBox2,
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     const Text(
                //       "Contact Person",
                //       style: TextStyle(
                //         fontFamily: 'hello',
                //         fontSize: 18,
                //         fontWeight: FontWeight.w500,
                //         color: Colors.white,
                //       ),
                //     ),
                //     vSizedBox1,
                //     CustomTextFormField(
                //       hintText: "Contact Person",
                //       controller:
                //           marketController.marketContactPersonController,
                //       textInputType: TextInputType.text,
                //       filled: true,
                //       fillColor: Colors.white,
                //       validator: (val) =>
                //           val.toString().isEmpty ? "Cannot be empty" : null,
                //       textInputAction: TextInputAction.next,
                //     ),
                //   ],
                // ),
                // vSizedBox2,
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     const Text(
                //       "Contact Number",
                //       style: TextStyle(
                //         fontFamily: 'hello',
                //         fontSize: 18,
                //         fontWeight: FontWeight.w500,
                //         color: Colors.white,
                //       ),
                //     ),
                //     vSizedBox1,
                //     CustomTextFormField(
                //       hintText: "Contact Number",
                //       controller: marketController.marketContactNoController,
                //       textInputType: TextInputType.number,
                //       onlyNumber: true,
                //       filled: true,
                //       fillColor: Colors.white,
                //       validator: (val) => val.toString().isEmpty
                //           ? "Cannot be empty"
                //           : !RegExp(r'^[9][7-8]\d{8}$').hasMatch(val)
                //               ? "Phone number not valid"
                //               : null,
                //       textInputAction: TextInputAction.next,
                //     ),
                //   ],
                // ),
                vSizedBox2,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Address",
                      style: TextStyle(
                        fontFamily: 'hello',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    vSizedBox1,
                    CustomTextFormField(
                      hintText: "Address",
                      controller: marketController.marketAddressController,
                      textInputType: TextInputType.text,
                      filled: true,
                      fillColor: Colors.white,
                      validator: (val) =>
                          val.toString().isEmpty ? "Cannot be empty" : null,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
                vSizedBox2,
                widget.isFromEdit ?? false
                    ? Container()
                    : Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.image,
                                size: size.aspectRatio * 55,
                                color: Colors.white,
                              ),
                              SizedBox(width: size.width * 0.01),
                              const Text(
                                "Image",
                                style: TextStyle(
                                  fontFamily: 'hello',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.012),
                          pickedMarketImage != null
                              ? GestureDetector(
                                  onTap: () {
                                    selectSource();
                                  },
                                  child: Image.file(
                                    pickedMarketImage!,
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    selectSource();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    height: size.height * 0.18,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          style: BorderStyle.solid),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: Icon(
                                          Icons.cloud_upload,
                                          color: Colors.white,
                                          size: size.height * 0.1,
                                        )),
                                        const Text(
                                          "Upload Your Image",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
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
                                if (marketController
                                        .marketFormState.currentState!
                                        .validate() &&
                                    selectedDeliveryMarketPlace.value != null &&
                                    selectedWarrantyMarketPlace.value != null &&
                                    selectedNegotiableMarketPlace.value !=
                                        null) {
                                  FocusScope.of(context).unfocus();

                                  widget.isFromEdit ?? false
                                      ? marketController.editMarketPlace(
                                          marketId: widget.market?.marketId
                                              .toString())
                                      : pickedMarketImage != null
                                          ? marketController.uploadMarketPlace(
                                              file: pickedMarketImage,
                                              isFromServiceScreen:
                                                  widget.isFromServiceScreen,
                                            )
                                          // ? Get.to(() => Payment(
                                          //       serviceType: "market",
                                          //       pickedImage: pickedMarketImage,
                                          //       isFromServiceScreen:
                                          //           widget.isFromServiceScreen,
                                          //     ))
                                          : errorToast(
                                              msg:
                                                  "Please select the image to upload");
                                } else {
                                  errorToast(msg: "Please fill the fields");
                                }
                              },
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickcitizenshipfront(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        pickedMarketImage = File(pickedImage.path);
        consolelog('picked image: $pickedMarketImage');
      });
    } else {
      consolelog('no profile picture selected');
    }
  }

  void selectSource() {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          child: AlertDialog(
            title: const Center(
                child: Text(
              "Select",
              style: TextStyle(fontSize: 21, color: Colors.black),
            )),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed: () {
                        pickcitizenshipfront(ImageSource.gallery);
                        back(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined),
                          SizedBox(
                            width: 1,
                          ),
                          Text("Gallery"),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      pickcitizenshipfront(ImageSource.camera);
                      back(context);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(
                          width: 1,
                        ),
                        Text("Camera"),
                      ],
                    )),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"))
            ],
          ),
        );
      },
    );
  }
}
