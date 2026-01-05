import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';

import '../../../network/services/userdetails/current_user_controller.dart';
import '../../user_screen/profile/edit_profile_user.dart';
import '../../widgets/custom_dialogs.dart';

class ServiceProfile extends StatefulWidget {
  const ServiceProfile({super.key});

  @override
  State<ServiceProfile> createState() => _ServiceProfileState();
}

class _ServiceProfileState extends State<ServiceProfile> {
  final controller = Get.put(CurrentUserController());
  final authController = Get.put(AuthController());
  File? _profileimage;
  String? token;

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    setState(() {
      token = apptoken;
    });
  }

  Future pickprofile(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _profileimage = File(pickedImage.path);
        print('picked image: $_profileimage');
      });
    } else {
      print('no profile picture selected');
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

  @override
  Widget build(BuildContext context) {
    // consolelog(controller.currentUserData.value.mobileNumber);
    Size size = MediaQuery.of(context).size;
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              color: Colors.white),
          child: Padding(
            padding: EdgeInsets.all(size.aspectRatio * 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Profile',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => EditProfileUser(
                            isFromServiceScreen: true,
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                ),
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
                                backgroundImage: FileImage(_profileimage!),
                              )
                            : CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 47,
                                backgroundImage: NetworkImage(
                                  "http://13.232.92.169:9000/api/allimg/image/${controller.currentUserData.value.picture}",
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
                          authController.uploadProfile(
                            _profileimage,
                            isFromServiceScreen: true,
                          );
                        } else {
                          errorToast(msg: "Please select the image to upload");
                        }
                        // uploadImage(_profileimage);
                        // saveImage(_profileimage?.path);
                      },
                      child: const Text('Save',
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
                SizedBox(
                  height: size.aspectRatio * 0.5,
                ),
                buildItem(
                    " ${controller.currentUserData.value.firstName.toString()} ${controller.currentUserData.value.lastName.toString()}",
                    Icons.person_outline),
                buildItem(
                    controller.currentUserData.value.mobileNumber.toString(),
                    Icons.phone),
                buildItem(controller.currentUserData.value.email.toString(),
                    Icons.alternate_email),
                buildItem(
                    controller.currentUserData.value.companyName.toString(),
                    Icons.business_outlined),
                buildItem(
                    controller.currentUserData.value.citizenshipNum.toString(),
                    Icons.credit_card),
                buildItem(controller.currentUserData.value.jobField.toString(),
                    Icons.credit_card),
                buildItem(controller.currentUserData.value.jobTitle.toString(),
                    Icons.credit_card),
              ],
            ),
          ),
        );
      }
    });
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
