import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/core/route_navigation.dart';
import 'package:smartsewa/network/models/vacancy_model.dart';
import 'package:smartsewa/network/services/exraServices/vacancy_controller.dart';
import 'package:smartsewa/views/widgets/custom_snackbar.dart';
import 'package:smartsewa/views/widgets/custom_text_form_field.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';
import '../../../core/states.dart';
import '../../user_screen/showExtraServices/user_vacancy/vacancy_template.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/custom_toasts.dart';

class UploadVaccancy extends StatefulWidget {
  final bool? isFromServiceScreen;
  final bool? isFromEdit;
  final VacancyResponseModel? vacancy;
  const UploadVaccancy(
      {Key? key, this.isFromServiceScreen, this.isFromEdit, this.vacancy})
      : super(key: key);

  @override
  State<UploadVaccancy> createState() => _UploadVaccancyState();
}

class _UploadVaccancyState extends State<UploadVaccancy> {
  VacancyController vacancyController = Get.put(VacancyController());
  File? pickedVacancyImage;
  String? token;

  @override
  void initState() {
    getToken();

    if (widget.vacancy != null) {
      vacancyController.vacancuyAddressController.text =
          widget.vacancy?.address ?? "";
      vacancyController.vacancyTitleController.text =
          widget.vacancy?.title ?? "";
      vacancyController.vacancyPositionController.text =
          widget.vacancy?.position ?? "";
      vacancyController.vacancyOfficeNameController.text =
          widget.vacancy?.officeName ?? "";
      vacancyController.vacancyQualificationController.text =
          widget.vacancy?.qualification ?? "";
      vacancyController.vacancyQuantityController.text =
          widget.vacancy?.quantity.toString() ?? "";
      vacancyController.vacancyContactController.text =
          widget.vacancy?.contact.toString() ?? "";
      vacancyController.vacancyApplyCvEmailController.text =
          widget.vacancy?.applyCvEmail ?? "";
      selectedVacancyStatus.value =
          widget.vacancy?.statusAvailable ?? false ? "Yes" : "No";
    }

    super.initState();
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    setState(() {
      token = apptoken;
    });
  }

  @override
  void dispose() {
    super.dispose();
    vacancyController.vacancyResetController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, "Post Vacancy"),
      body: Padding(
        padding: screenLeftRightPadding,
        child: Form(
          key: vacancyController.vacancyFormState,
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
                    controller: vacancyController.vacancyTitleController,
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
                    "Position",
                    style: TextStyle(
                      fontFamily: 'hello',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "Position",
                    controller: vacancyController.vacancyPositionController,
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
                    "Quantity",
                    style: TextStyle(
                      fontFamily: 'hello',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "Quantity",
                    controller: vacancyController.vacancyQuantityController,
                    textInputType: TextInputType.number,
                    onlyNumber: true,
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
                    "Qualification",
                    style: TextStyle(
                      fontFamily: 'hello',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "Qualification",
                    controller:
                        vacancyController.vacancyQualificationController,
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
                    "Office Name",
                    style: TextStyle(
                      fontFamily: 'hello',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "Office Name",
                    controller: vacancyController.vacancyOfficeNameController,
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
                    controller: vacancyController.vacancuyAddressController,
                    filled: true,
                    fillColor: Colors.white,
                    validator: (val) =>
                        val.toString().isEmpty ? "Cannot be empty" : null,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
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
              //       controller: vacancyController.vacancyContactController,
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
                    "Apply CV Email",
                    style: TextStyle(
                      fontFamily: 'hello',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  vSizedBox1,
                  CustomTextFormField(
                    hintText: "Apply CV Email",
                    controller: vacancyController.vacancyApplyCvEmailController,
                    filled: true,
                    fillColor: Colors.white,
                    validator: (val) => val.toString().isEmpty
                        ? "Cannot be empty"
                        : !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\"
                                    r".[a-zA-Z]+")
                                .hasMatch(val)
                            ? "Enter a valid email"
                            : null,
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
                            const Icon(
                              Icons.person_outline,
                              size: 30,
                              color: Color(0xFF889AAD),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Vacancy Image",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.012),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  child: AlertDialog(
                                    title: const Center(
                                        child: Text(
                                      "Select",
                                      style: TextStyle(
                                          fontSize: 21, color: Colors.black),
                                    )),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            onPressed: () {
                                              pickedVacancyImage = null;
                                              back(context);
                                              Get.to(() => VacancyTemplate(
                                                    token: token,
                                                  ));
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.camera_alt_outlined),
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                Text("Templates"),
                                              ],
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Theme.of(context)
                                                              .primaryColor)),
                                              onPressed: () async {
                                                Get.back();
                                                selectSource();
                                                // final imagePicker =
                                                //     ImagePicker();
                                                // final pickedImage =
                                                //     await imagePicker.pickImage(
                                                //         source: ImageSource
                                                //             .gallery);

                                                // if (pickedImage != null) {
                                                //   setState(() {
                                                //     pickedVacancyImage =
                                                //         File(pickedImage.path);
                                                //     consolelog(
                                                //         'picked image: $pickedVacancyImage');
                                                //     selectedVacancyTemplate
                                                //         .value = null;
                                                //   });
                                                //   back(context);
                                                // } else {
                                                //   back(context);
                                                //   logger(
                                                //     'no profile picture selected',
                                                //     loggerType:
                                                //         LoggerType.error,
                                                //   );
                                                // }
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.image_outlined),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Text("Others"),
                                                ],
                                              )),
                                        ),
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
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.black26),
                                color: Colors.white),
                            height: appHeight(context) * 0.066,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        pickedVacancyImage != null ||
                                                selectedVacancyTemplate.value !=
                                                    null
                                            ? 'ReUpload Picture'
                                            : 'Upload Picture',
                                        style: const TextStyle(
                                          color: Colors.black38,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Colors.black38,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        vSizedBox0,
                        ValueListenableBuilder(
                          valueListenable: selectedVacancyTemplate,
                          builder: (context, value, child) => value != null
                              ? Image.network(value)
                              : pickedVacancyImage != null
                                  ? Image.file(
                                      pickedVacancyImage!,
                                    )
                                  : Container(),
                        ),
                      ],
                    ),
              vSizedBox2,
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Obx(
                    () => vacancyController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : AppButton(
                            name: "Submit",
                            onPressed: () async {
                              if (vacancyController
                                  .vacancyFormState.currentState!
                                  .validate()) {
                                FocusScope.of(context).unfocus();
                                widget.isFromEdit ?? false
                                    ? vacancyController.editVacancies(
                                        isFromServiceScreen:
                                            widget.isFromServiceScreen,
                                        vacancyId: widget.vacancy?.vacancyId
                                            .toString())
                                    : pickedVacancyImage != null ||
                                            selectedVacancyTemplate.value !=
                                                null
                                        ? vacancyController.uploadVacancies(
                                            file: pickedVacancyImage,
                                            isFromServiceScreen:
                                                widget.isFromServiceScreen,
                                          )
                                        // ? Get.to(() => Payment(
                                        //       serviceType: "vacancy",
                                        //       pickedImage: pickedVacancyImage,
                                        //       isFromServiceScreen:
                                        //           widget.isFromServiceScreen,
                                        //     ))
                                        : CustomSnackBar.showSnackBar(
                                            message:
                                                "Please select the image to upload",
                                            color: Colors.red,
                                          );
                              } else {
                                CustomSnackBar.showSnackBar(
                                  title: "Please fill the fields",
                                  color: Colors.red,
                                );
                              }
                            }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {

      // _cropImage(File(pickedImage.path));
      // setState(() {
      //   selectedOfferImage = File(pickedImage.path);
      //   consolelog('picked image: $selectedOfferImage');
      // });
    } else {
      errorToast(msg: "No profile picture selected");
      consolelog('no profile picture selected');
    }
  }

  // Future<void> _cropImage(File picked) async {
  //   final CroppedFile? croppedFile = await ImageCropper().cropImage(
  //     sourcePath: picked.path,
  //     compressFormat: ImageCompressFormat.jpg,
  //     compressQuality: 100,
  //     cropStyle: CropStyle.rectangle,
  //     aspectRatioPresets: const [
  //       CropAspectRatioPreset.ratio4x3,
  //     ],
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: 'Cropper',
  //         toolbarColor: Theme.of(context).primaryColor,
  //         toolbarWidgetColor: Colors.white,
  //         initAspectRatio: CropAspectRatioPreset.ratio4x3,
  //         lockAspectRatio: true,
  //         hideBottomControls: true,
  //       ),
  //       IOSUiSettings(
  //         title: 'Cropper',
  //       ),
  //       WebUiSettings(
  //         context: context,
  //         presentStyle: CropperPresentStyle.dialog,
  //         boundary: const CroppieBoundary(
  //           width: 520,
  //           height: 520,
  //         ),
  //         viewPort: const CroppieViewPort(
  //           width: 480,
  //           height: 360,
  //           type: 'square', // ❗ must be square/rectangular
  //         ),
  //         enableExif: true,
  //         enableZoom: true,
  //         showZoomer: true,
  //       ),
  //     ],
  //   );
  //
  //   if (croppedFile != null) {
  //     setState(() {
  //       pickedVacancyImage = File(croppedFile.path);
  //       consolelog('picked image: $pickedVacancyImage');
  //       selectedVacancyTemplate.value = null;
  //     });
  //   } else {
  //     errorToast(msg: "Image cropping cancelled");
  //   }
  // }


  // _cropImage(File picked) async {
  //   final croppedFile = await ImageCropper().cropImage(
  //     sourcePath: picked.path,
  //     compressFormat: ImageCompressFormat.jpg,
  //     compressQuality: 100,
  //     cropStyle: CropStyle.rectangle,
  //     aspectRatioPresets: [
  //       // CropAspectRatioPreset.original,
  //       // CropAspectRatioPreset.ratio16x9,
  //       CropAspectRatioPreset.ratio4x3,
  //     ],
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: 'Cropper',
  //         toolbarColor: Theme.of(context).primaryColor,
  //         toolbarWidgetColor: Colors.white,
  //         initAspectRatio: CropAspectRatioPreset.original,
  //         lockAspectRatio: true,
  //         cropGridColor: Colors.white,
  //         hideBottomControls: true,
  //       ),
  //       IOSUiSettings(
  //         title: 'Cropper',
  //       ),
  //       WebUiSettings(
  //         context: context,
  //         presentStyle: CropperPresentStyle.dialog,
  //         boundary: const CroppieBoundary(
  //           width: 520,
  //           height: 520,
  //         ),
  //         viewPort:
  //             const CroppieViewPort(width: 480, height: 480, type: 'circle'),
  //         enableExif: true,
  //         enableZoom: true,
  //         showZoomer: true,
  //       ),
  //     ],
  //   );
  //   if (croppedFile != null) {
  //     setState(() {
  //       pickedVacancyImage = File(croppedFile.path);
  //       consolelog('picked image: $pickedVacancyImage');
  //       selectedVacancyTemplate.value = null;
  //     });
  //   } else {
  //     errorToast(msg: "No profile picture selected");
  //   }
  // }

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
                        pickImage(ImageSource.gallery);
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
                      pickImage(ImageSource.camera);
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
