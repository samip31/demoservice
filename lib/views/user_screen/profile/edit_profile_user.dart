import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/network/services/userdetails/user_edit.dart';
import 'package:smartsewa/views/widgets/custom_dialogs.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

import '../../../network/services/userdetails/current_user_controller.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/ovelayed_loading_screen.dart';
import '../approval/map_controller.dart';
import '../approval/open_map_screen.dart';

class EditProfileUser extends StatefulWidget {
  final mapController = Get.put(MapController());
  final bool? isFromServiceScreen;
  EditProfileUser({super.key, this.isFromServiceScreen = false});

  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final userController = Get.put(UserEditController());
  final authController = Get.put(AuthController());
  final storeController = Get.put(CurrentUserController());

  bool onpressed = false;
  GoogleMapController? googleMapController;
  final Completer<GoogleMapController> completeGoogleMapController =
      Completer();
  // LatLng selectedLatLng = const LatLng(27.707795, 85.343362);
  static const CameraPosition kGoogle = CameraPosition(
    target: LatLng(27.707795, 85.343362),
    zoom: 14.4746,
  );
  final List<Marker> marker = <Marker>[
    // const Marker(
    //     markerId: MarkerId('1'),
    //     position: LatLng(27.707795, 85.343362),
    //     infoWindow: InfoWindow(
    //       title: 'My Position',
    //     )),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, ""),
      body:
          // onpressed
          //     ? openMap()
          //     :
          Stack(
        children: [
          ListView(
            children: [
              // SizedBox(height: size.height * 0.06),
              Container(
                width: double.infinity,
                height: size.height * 1,
                decoration: const BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   topRight: Radius.circular(30),
                  //   topLeft: Radius.circular(30),
                  // ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.all(size.aspectRatio * 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: size.height * 0.018),
                      buildTextField(
                          "Enter your first name",
                          storeController.currentUserData.value.firstName
                              .toString(),
                          firstNameController),
                      buildTextField(
                          "Enter your last name",
                          storeController.currentUserData.value.lastName
                              .toString(),
                          lastNameController),
                      // SizedBox(height: size.height * 0.018),
                      // ImageBox(
                      //     image: _profileimage,
                      //     onTap: () {
                      //       pickprofile();
                      //     },
                      //     name: 'Change Profile Picture'),
                      SizedBox(height: size.height * 0.018),
                      locationButton(),
                      SizedBox(height: size.height * 0.07),
                      // const Spacer(),
                      AppButton(
                        name: "Save",
                        onPressed: () {
                          if (firstNameController.text.isEmpty) {
                            firstNameController.text = storeController
                                .currentUserData.value.firstName
                                .toString();
                          }
                          if (lastNameController.text.isEmpty) {
                            lastNameController.text = storeController
                                .currentUserData.value.lastName
                                .toString();
                          }
                          consolelog("data");
                          CustomDialogs.fullLoadingDialog(
                              context: context, data: "Updating Profile...");
                          userController.userProfileEdit(
                            firstNameController.text,
                            lastNameController.text,
                            selectedLatLng.value?.latitude.toString() ??
                                storeController.currentUserData.value.latitude
                                    .toString(),
                            selectedLatLng.value?.longitude.toString() ??
                                storeController.currentUserData.value.longitude
                                    .toString(),
                            isFromServiceScreen: widget.isFromServiceScreen,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => widget.mapController.isMapLoading.value
                ? const OverlayedLoadingScreen()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  buildTextField(
      String question, String value, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // name of the edit box
        Text(
          question,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        TextFormField(
          onChanged: (value) {
            setState(() {
              value = controller.text;
            });
          },
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF889AAD)),
            ),
            hintText: value,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.040),
      ],
    );
  }

  ///Upload profile image
  File? _profileimage;

  Future pickprofile() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileimage = File(pickedImage.path);
        print('picked image: $_profileimage');
      });
    } else {
      print('no profile picture selected');
    }
  }

  ///*******Code For Google Map*******//////

  final Completer<GoogleMapController> _controller = Completer();
  final LatLng _selectedLatLng = const LatLng(27.707795, 85.343362);
  LocationPermission? permission;

  static const CameraPosition _kGoogle = CameraPosition(
    target: LatLng(27.707795, 85.343362),
    zoom: 14.4746,
  );
  final List<Marker> _marker = <Marker>[
    // const Marker(
    //     markerId: MarkerId('1'),
    //     position: LatLng(27.707795, 85.343362),
    //     infoWindow: InfoWindow(
    //       title: 'My Position',
    //     )),
  ];
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     currentLocation = await location.getLocation();

  //     setState(() {
  //       _selectedLatLng = LatLng(
  //         currentLocation!.latitude!,
  //         currentLocation!.longitude!,
  //       );
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  locationButton() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              CupertinoIcons.map,
              color: Colors.black45,
            ),
            const SizedBox(width: 5),
            Text(
              'Add Your Location',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        AppButton(
          icon: Icons.location_on,
          name: "Open Map",
          onPressed: () async {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.deniedForever) {
              await Geolocator.openAppSettings();
            } else if (permission != LocationPermission.denied &&
                permission != LocationPermission.deniedForever) {
              widget.mapController.isMapLoading.value = true;
              Get.to(() => OpenMapScreen(
                    completeGoogleMapController: completeGoogleMapController,
                    kGoogle: kGoogle,
                    marker: marker,
                    onpressed: onpressed,
                  ));
            }

            // setState(() {
            //   onpressed = true;
            // });
            // getUserCurrentLocation().then((value) async {
            //   print("${value.latitude} ${value.longitude}");

            //   // // marker added for current users location
            //   // _marker.add(Marker(
            //   //   markerId: const MarkerId("2"),
            //   //   position: LatLng(value.latitude, value.longitude),
            //   //   infoWindow: const InfoWindow(
            //   //     title: 'My Current Location',
            //   //   ),
            //   // ));

            //   // specified current users location
            //   CameraPosition cameraPosition = CameraPosition(
            //     target: LatLng(value.latitude, value.longitude),
            //     zoom: 14,
            //   );

            //   final GoogleMapController controller = await _controller.future;
            //   controller.animateCamera(
            //       CameraUpdate.newCameraPosition(cameraPosition));
            //   setState(() {});
            // });
          },
        ),
        SizedBox(height: size.height * 0.01),
        ValueListenableBuilder(
          valueListenable: selectedLatLng,
          builder: (context, value, child) => Text(
            value == null
                ? // "Address: $_selectedLatLng",
                "Address: ${storeController.currentUserData.value.latitude}, ${storeController.currentUserData.value.longitude}"
                : "Address: ${value.latitude}, ${value.longitude}",
            style: const TextStyle(
              fontFamily: 'hello',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
          ),
        ),
      ],
    );
  }

  // openMap() {
  //   Size size = MediaQuery.of(context).size;
  //   return Column(
  //     children: [
  //       // const SizedBox(height: 100),
  //       Expanded(
  //         // height: size.height * 0.795,
  //         // width: 500,
  //         // color: Colors.red,
  //         child: GoogleMap(
  //           initialCameraPosition: _kGoogle,
  //           markers: Set<Marker>.of(_marker),
  //           mapType: MapType.normal,
  //           myLocationEnabled: true,
  //           compassEnabled: true,
  //           onMapCreated: (GoogleMapController controller) {
  //             _controller.complete(controller);
  //           },
  //           onTap: (LatLng latLng) {
  //             setState(() {
  //               _selectedLatLng = latLng;
  //               _marker.clear();
  //               _marker.add(
  //                 Marker(
  //                   markerId: const MarkerId('Selected Location'),
  //                   position: _selectedLatLng,
  //                   infoWindow: InfoWindow(
  //                     title: _selectedLatLng.toString(),
  //                   ),
  //                 ),
  //               );
  //             });
  //           },
  //           // onTap: (LatLng latLng) {
  //           //   setState(
  //           //     () {
  //           //       _selectedLatLng = latLng;
  //           //     },
  //           //   );
  //           // },
  //           // initialCameraPosition: currentLocation != null
  //           //     ? CameraPosition(
  //           //         target: LatLng(
  //           //           currentLocation!.latitude!,
  //           //           currentLocation!.longitude!,
  //           //         ),
  //           //         zoom: 14,
  //           //       )
  //           //     : const CameraPosition(
  //           //         target: LatLng(27.706969, 85.341963),
  //           //         zoom: 14,
  //           //       ),
  //           // initialCameraPosition: CameraPosition(
  //           //   target: _selectedLatLng,
  //           //   zoom: 14,
  //           // ),
  //           // ignore: unnecessary_null_comparison
  //           // markers: _selectedLatLng != null
  //           //     ? {
  //           //         Marker(
  //           //             markerId: const MarkerId('Selected Location'),
  //           //             position: _selectedLatLng,
  //           //             infoWindow:
  //           //                 InfoWindow(title: _selectedLatLng.toString())),
  //           //       }
  //           //     : {},
  //         ),
  //       ),
  //       Container(
  //         height: 50,
  //         width: double.infinity,
  //         color: Theme.of(context).primaryColor,
  //         child: Align(
  //           alignment: Alignment.bottomRight,
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: TextButton(
  //               style: ButtonStyle(
  //                   shape: MaterialStatePropertyAll(RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8))),
  //                   backgroundColor:
  //                       const MaterialStatePropertyAll(Colors.blue)),
  //               child: const Text(
  //                 'Ok',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   onpressed = false;
  //                 });
  //               },
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
