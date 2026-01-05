import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/route_navigation.dart';

import 'package:smartsewa/network/services/image_services/image_controller.dart';
import 'package:smartsewa/views/user_screen/profile/edit_profile_user.dart';
import 'package:smartsewa/views/widgets/custom_dialogs.dart';
import 'package:smartsewa/views/widgets/custom_snackbar.dart';
import 'package:smartsewa/views/widgets/custom_text.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';
import '../../../network/base_client.dart';
import '../../../network/services/authServices/auth_controller.dart';
import '../../../network/services/userdetails/current_user_controller.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../approval/approval_screen.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final controller = Get.put(CurrentUserController());
  final _getController = Get.put(AuthController());
  final imageController = Get.put(ImageController());

  String baseUrl = BaseClient().baseUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // controller.getCurrentUser();
    // consolelog(
    //     "http://13.232.92.169:9000/api/allimg/image/${controller.picture}");
    return Scaffold(
      appBar: myAppbar(context, true, "Profile"),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: size.height * 1,
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.all(size.aspectRatio * 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Get.to(() => EditProfileUser());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor),
                            child: const Text(
                              "Edit Profile",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      // ImageBox(
                      //     image: _profileimage,
                      //     onTap: () {
                      //       pickprofile();
                      //     },
                      //     name: 'Profile Picture'),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            selectSource();
                            // if (_profileimage != null) {
                            //   _getController.uploadProfile(_profileimage!);
                            // }
                            // _getController.uploadProfile(_profileimage);
                          },
                          child: Stack(
                            children: [
                              _profileimage != null
                                  ? CircleAvatar(
                                      radius: 47,
                                      backgroundImage:
                                          FileImage(_profileimage!),
                                    )
                                  : CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      radius: 47,
                                      backgroundImage: NetworkImage(
                                        "$baseUrl/api/allimg/image/${controller.currentUserData.value.picture}",
                                        headers: {
                                          'Authorization': "Bearer $token",
                                        },
                                      ),
                                    ),
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: Icon(Icons.camera_alt_outlined),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _profileimage != null
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          onPressed: () {
                            if (_profileimage != null) {
                              CustomDialogs.fullLoadingDialog(
                                  context: context, data: "Image Uploading...");
                              _getController.uploadProfile(_profileimage);
                              // .then((value) => setState(() {
                              //       _profileimage = null;
                              //     }));
                            } else {
                              CustomSnackBar.showSnackBar(
                                  title: "Please select the image to upload",
                                  color: Colors.red);
                            }
                            // uploadImage(_profileimage);
                            // saveImage(_profileimage?.path);
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      const Text(
                        '  Details.',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      buildItem(
                          " ${controller.currentUserData.value.firstName.toString()} ${controller.currentUserData.value.lastName.toString()}",
                          Icons.person_outline),
                      buildItem(
                          controller.currentUserData.value.mobileNumber
                              .toString(),
                          Icons.phone),
                      buildItem(
                          controller.currentUserData.value.email.toString(),
                          Icons.alternate_email),
                      SizedBox(height: size.height * 0.1),
                      controller.workStatus.value == true
                          ? Container()
                          : controller.currentUserData.value.approval == true
                              ? CustomText.ourText(
                                  "Your request for service provider has been submitted.",
                                  color: Colors.black,
                                )
                              : AppButton(
                                  name: 'Become a Service Provider',
                                  onPressed: () {
                                    Get.to(
                                      () => ApprovalScreen(
                                        mobileNumber: controller
                                            .currentUserData.value.mobileNumber
                                            .toString(),
                                        password: controller
                                            .currentUserData.value.password
                                            .toString(),
                                        email: controller
                                            .currentUserData.value.email
                                            .toString(),
                                      ),
                                    );
                                  },
                                ),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  String? token;
  //  String baseUrl = BaseClient().baseUrl;
  @override
  void initState() {
    // imageController.fetchImages(controller.picture);
    getToken();
    // controller.getCurrentUser();
    super.initState();
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    // int? tid = prefs.getInt("id");
    setState(() {
      token = apptoken;
    });
  }

  File? _profileimage;
  // late SharedPreferences prefs;
  // String? _imagepath;

  Future pickprofile(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _profileimage = File(pickedImage.path);
        consolelog('picked image: $_profileimage');
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
                        pickprofile(ImageSource.gallery);
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
                      pickprofile(ImageSource.camera);
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

  buildItem(String name, dynamic icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 32,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                  fontFamily: 'hello',
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  decoration: TextDecoration.none),
            ),
          )
        ],
      ),
    );
  }
}
