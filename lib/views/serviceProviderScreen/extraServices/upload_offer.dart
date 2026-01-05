import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';
import '../../../core/development/console.dart';
import '../../../core/dimension.dart';
import '../../../core/route_navigation.dart';
import '../../../network/services/exraServices/offer_controller.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/custom_toasts.dart';
import '../../widgets/textfield_box/bstring_textfield.dart';

class UploadOffer extends StatefulWidget {
  final bool? isFromEdit;
  final int? offerEditId;
  final String? offerTitle;
  final bool? isFromServiceScreen;
  const UploadOffer(
      {Key? key,
        this.isFromEdit,
        this.offerEditId,
        this.offerTitle,
        this.isFromServiceScreen})
      : super(key: key);

  @override
  State<UploadOffer> createState() => _UploadOfferState();
}

class _UploadOfferState extends State<UploadOffer> {
  final offerController = Get.put(OfferController());
  File? selectedOfferImage;

  @override
  void initState() {
    super.initState();
    if (widget.isFromEdit ?? false) {
      offerController.offerTitleController.text = widget.offerTitle ?? "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    offerController.clearTextFieldValue();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, "Upload Offer"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: offerController.offerFormState,
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.02),
              BStringTextField(
                name: "Category",
                controller: offerController.offerTitleController,
                boxIcon: Icons.security_update_good_sharp,
                hintText: "Enter your category",
              ),
              SizedBox(height: size.height * 0.02),
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
              selectedOfferImage != null
                  ? GestureDetector(
                onTap: () {
                  selectSource();
                },
                child: Image.file(
                  selectedOfferImage!,
                ),
              )
                  : InkWell(
                onTap: () async {
                  selectSource();
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
                        if (offerController.offerFormState.currentState!
                            .validate() &&
                            selectedOfferImage != null) {
                          FocusScope.of(context).unfocus();
                          widget.isFromEdit ?? false
                              ? offerController.editOffers(
                            citizenshipFront: selectedOfferImage,
                            offerId: widget.offerEditId.toString(),
                          )
                              : offerController.uploadOffers(
                            citizenshipFront: selectedOfferImage,
                            isFromServiceScreen:
                            widget.isFromServiceScreen,
                          );
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickcitizenshipfront(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      _cropImage(File(pickedImage.path));
    } else {
      errorToast(msg: "No profile picture selected");
      consolelog('no profile picture selected');
    }
  }

  Future<void> _cropImage(File picked) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: picked.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio4x3,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio4x3,
          ],
          hideBottomControls: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: const CropperSize(
            width: 520,
            height: 520,
          ),
          // viewPort: const CropperViewPort(
          //   width: 480,
          //   height: 480,
          //   type: 'circle',
          // ),
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        selectedOfferImage = File(croppedFile.path);
      });
    } else {
      errorToast(msg: "Image cropping cancelled");
    }
  }

  void selectSource() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Select",
              style: TextStyle(fontSize: 21, color: Colors.black),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () {
                    pickcitizenshipfront(ImageSource.gallery);
                    back(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_outlined),
                      SizedBox(width: 5),
                      Text("Gallery"),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
                    SizedBox(width: 5),
                    Text("Camera"),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}