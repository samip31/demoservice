import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

import '../../../network/services/exraServices/offer_controller.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/custom_snackbar.dart';

class UploadOfferImage extends StatefulWidget {
  const UploadOfferImage({super.key});

  @override
  State<UploadOfferImage> createState() => _UploadOfferImageState();
}

class _UploadOfferImageState extends State<UploadOfferImage> {
  final offerController = Get.put(OfferController());

  File? selectedOfferImage;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: myAppbar(context, true, "Post Offer Image"),
      body: SingleChildScrollView(
        padding: screenLeftRightPadding,
        child: Column(
          children: [
            selectedOfferImage != null
                ? Image.file(
                    selectedOfferImage!,
                  )
                : InkWell(
                    onTap: () async {
                      final imagePicker = ImagePicker();
                      final pickedImage = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (pickedImage != null) {
                        setState(() {
                          selectedOfferImage = File(pickedImage.path);
                        });
                      } else {
                        CustomSnackBar.showSnackBar(
                            color: Colors.red, title: "Image not selected");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: appHeight(context) * 0.18,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              style: BorderStyle.solid)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.cloud_upload,
                              color: Colors.white,
                              size: appHeight(context) * 0.1,
                            ),
                          ),
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
            SizedBox(height: appHeight(context) * 0.012),
            Obx(
              () => Center(
                child: Padding(
                  padding: EdgeInsets.all(size.aspectRatio * 75.0),
                  child: offerController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : AppButton(
                          name: "Submit",
                          onPressed: () {
                            if (selectedOfferImage != null) {
                              FocusScope.of(context).unfocus();
                              offerController.uploadImage();
                            } else {
                              CustomSnackBar.showSnackBar(
                                title: "Please select the image",
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
