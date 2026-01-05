import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

import '../../../network/services/userdetails/edit_service.dart';
import '../../../network/services/userdetails/current_user_controller.dart';
import '../../widgets/buttons/app_buttons.dart';

class ServiceProviderSettingPage extends StatefulWidget {
  const ServiceProviderSettingPage({super.key});

  @override
  State<ServiceProviderSettingPage> createState() =>
      _ServiceProviderSettingPageState();
}

class _ServiceProviderSettingPageState
    extends State<ServiceProviderSettingPage> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final userController = Get.put((ServiceProviderController()));
  final authController = Get.put(AuthController());
  CurrentUserController storeController = Get.put(CurrentUserController());
  bool isVisible = false;

  String profile =
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg';
  String? token;
  //  String baseUrl = BaseClient().baseUrl;
  @override
  void initState() {
    // imageController.fetchImages(controller.picture);
    getToken();
    storeController.getCurrentUser();
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

  bool onPressed = false;
  GoogleMapController? googleMapController;
  final Completer<GoogleMapController> _controller = Completer();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppbar(context, true, ""),
      body: SafeArea(
        child: onPressed
            ? openMap()
            : Column(
                children: [
                  SizedBox(height: size.height * 0.06),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
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
                              Center(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "http://13.232.92.169:9000/api/allimg/image/${storeController.currentUserData.value.picture}",
                                    headers: {
                                      'Authorization': "Bearer $token",
                                    },
                                  ),
                                  radius: 50,
                                ),
                              ),
                              SizedBox(height: size.height * 0.040),
                              buildTextField(
                                  "Enter your company name",
                                  storeController
                                      .currentUserData.value.companyName
                                      .toString(),
                                  companyNameController),
                              buildTextField(
                                  "Enter your first name",
                                  storeController
                                      .currentUserData.value.firstName
                                      .toString(),
                                  firstNameController),
                              buildTextField(
                                  "Enter your last name",
                                  storeController.currentUserData.value.lastName
                                      .toString(),
                                  lastNameController),
                              Text(
                                "Change your location",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(selectedLatLng.toString())),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          onPressed = true;
                                        });
                                        getUserCurrentLocation()
                                            .then((value) async {
                                          print(
                                              "${value.latitude} ${value.longitude}");

                                          // // marker added for current users location
                                          // _marker.add(Marker(
                                          //   markerId: const MarkerId("2"),
                                          //   position: LatLng(value.latitude, value.longitude),
                                          //   infoWindow: const InfoWindow(
                                          //     title: 'My Current Location',
                                          //   ),
                                          // ));

                                          // specified current users location
                                          CameraPosition cameraPosition =
                                              CameraPosition(
                                            target: LatLng(value.latitude,
                                                value.longitude),
                                            zoom: 14,
                                          );

                                          final GoogleMapController controller =
                                              await _controller.future;
                                          controller.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                  cameraPosition));
                                          setState(() {});
                                        });
                                      },
                                      child: const Text("Open Map")),
                                ],
                              ),
                              const SizedBox(height: 10),
                              AppButton(
                                name: "Save",
                                onPressed: () {
                                  if (companyNameController.text.isEmpty) {
                                    companyNameController.text = storeController
                                        .currentUserData.value.companyName
                                        .toString();
                                  }

                                  if (firstNameController.text.isEmpty) {
                                    firstNameController.text = storeController
                                        .currentUserData.value.firstName
                                        .toString();
                                  }
                                  if (lastNameController.text.isEmpty) {
                                    lastNameController.text = storeController
                                        .currentUserData.value.lastName
                                        .toString();
                                  } else {
                                    if (selectedLatLng ==
                                        const LatLng(27.707795, 85.343362)) {
                                      Get.snackbar(
                                          "Error", "Please add your location",
                                          backgroundColor: Colors.red);
                                    }
                                    {
                                      userController.serviceProviderEdit(
                                        companyNameController.text,
                                        firstNameController.text,
                                        lastNameController.text,
                                        selectedLatLng.latitude.toString(),
                                        selectedLatLng.longitude.toString(),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

  LatLng selectedLatLng = const LatLng(27.707795, 85.343362);
  openMap() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // const SizedBox(height: 100),
        Expanded(
          // height: size.height * 0.795,
          // width: 500,
          // color: Colors.red,
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            markers: Set<Marker>.of(_marker),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (LatLng latLng) {
              setState(() {
                selectedLatLng = latLng;
                _marker.clear();
                _marker.add(
                  Marker(
                    markerId: const MarkerId('Selected Location'),
                    position: selectedLatLng,
                    infoWindow: InfoWindow(
                      title: selectedLatLng.toString(),
                    ),
                  ),
                );
              });
            },
            // onTap: (LatLng latLng) {
            //   setState(
            //     () {
            //       _selectedLatLng = latLng;
            //     },
            //   );
            // },
            // initialCameraPosition: currentLocation != null
            //     ? CameraPosition(
            //         target: LatLng(
            //           currentLocation!.latitude!,
            //           currentLocation!.longitude!,
            //         ),
            //         zoom: 14,
            //       )
            //     : const CameraPosition(
            //         target: LatLng(27.706969, 85.341963),
            //         zoom: 14,
            //       ),
            // initialCameraPosition: CameraPosition(
            //   target: _selectedLatLng,
            //   zoom: 14,
            // ),
            // ignore: unnecessary_null_comparison
            // markers: _selectedLatLng != null
            //     ? {
            //         Marker(
            //             markerId: const MarkerId('Selected Location'),
            //             position: _selectedLatLng,
            //             infoWindow:
            //                 InfoWindow(title: _selectedLatLng.toString())),
            //       }
            //     : {},
          ),
        ),
        Container(
          height: 50,
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    backgroundColor:
                        const MaterialStatePropertyAll(Colors.blue)),
                child: const Text(
                  'Ok',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    onPressed = false;
                  });
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  // openMap() {
  //   return Column(
  //     children: [
  //       // const SizedBox(height: 100),
  //       Expanded(
  //         // height: 400,
  //         // width: 500,
  //         // color: Colors.red,
  //         child: GoogleMap(
  //           onTap: (LatLng latLng) {
  //             setState(
  //               () {
  //                 selectedLatLng = latLng;
  //               },
  //             );
  //           },
  //           initialCameraPosition: const CameraPosition(
  //             target: LatLng(27.706969, 85.341963),
  //             zoom: 14,
  //           ),
  //           // ignore: unnecessary_null_comparison
  //           markers: selectedLatLng != null
  //               ? {
  //                   Marker(
  //                       markerId: const MarkerId('Selected Location'),
  //                       position: selectedLatLng,
  //                       infoWindow:
  //                           InfoWindow(title: selectedLatLng.toString())),
  //                 }
  //               : {},
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
  //                   onPressed = false;
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
