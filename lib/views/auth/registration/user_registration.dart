import 'dart:async';
import 'dart:io';
import 'dart:math' show Random;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/enum.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/views/auth/registration/registration_otp_screen.dart';
import 'package:smartsewa/views/user_screen/approval/open_map_screen.dart';
import 'package:smartsewa/views/widgets/custom_dialogs.dart';
import 'package:smartsewa/views/widgets/custom_snackbar.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';
import 'package:smartsewa/views/widgets/textfield_box/confirm_password_field.dart';
import 'package:smartsewa/views/widgets/textfield_box/email_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../core/states.dart';
import '../../user_screen/approval/map_controller.dart';
import '../../user_screen/drawer screen/privacypolicyscreen.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/ovelayed_loading_screen.dart';
import '../../widgets/textfield_box/string_textfield.dart';
import '../../widgets/textfield_box/passwordfield.dart';
import '../../widgets/textfield_box/phone_text_field.dart';

class UserRegistration extends StatefulWidget {
  final mapController = Get.put(MapController());
  UserRegistration({Key? key}) : super(key: key);

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  int _randomNumber = 0;
  final controller = Get.put(AuthController());
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isChecked = false;

  bool _obscureText = true;

  void showpassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _formkey = GlobalKey<FormState>();

  ///*******Code For Google Map*******//////
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
  LocationPermission? permission;

  Future<void> urlLaunch(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.inAppWebView,
    )) {
      throw 'Error launching URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, "Register"),
      body:
          // onpressed
          //     ? openMap()
          //     :
          SafeArea(
        child: Stack(
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  // SizedBox(height: size.height * 0.05),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.only(
                        //   topLeft: Radius.circular(22),
                        //   topRight: Radius.circular(22),
                        // ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(size.aspectRatio * 55),
                        child: ListView(
                          children: [
                            SizedBox(height: size.height * 0.025),
                            Row(
                              children: [
                                SizedBox(
                                  width: size.width * 0.43,
                                  child: StringTextField(
                                    fill: false,
                                    controller: _firstnameController,
                                    name: 'First Name',
                                    boxIcon: Icons.person_outline,
                                    hintText: 'Your first name',
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                Expanded(
                                  child: StringTextField(
                                    fill: false,
                                    controller: _lastnameController,
                                    name: 'Last Name',
                                    boxIcon: Icons.person_outline,
                                    hintText: 'Your last name',
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(height: size.height * 0.025),
                            // ImageBox(
                            //     image: _profileimage,
                            //     onTap: () {
                            //       pickprofile();
                            //     },
                            //     name: 'Profile Picture'),
                            SizedBox(height: size.height * 0.025),
                            PhoneTextField(
                              controller: _phoneController,
                            ),
                            SizedBox(height: size.height * 0.025),
                            EmailTextField(controller: _emailController),
                            SizedBox(height: size.height * 0.025),
                            PasswordTextField(
                              name: 'Password',
                              controller: _passwordController,
                            ),
                            SizedBox(height: size.height * 0.025),
                            ConfirmPasswordTextField(
                              name: 'Confirm Password',
                              controller: _confirmPasswordController,
                              passwordController: _passwordController,
                            ),
                            SizedBox(height: size.height * 0.025),
                            locationButton(),
                            SizedBox(height: size.height * 0.025),
                            CheckboxListTile(
                              title: Semantics(
                                excludeSemantics: true,
                                label: "I agree GDPR available HERE",
                                child: RichText(
                                  text: TextSpan(
                                    text: "I have read and agree to the ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "terms and conditions.",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Get.to(() =>
                                              const PrivacypolicyScreen()),
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: " and ",
                                      ),
                                      TextSpan(
                                        text: "Privacy Policy",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            urlLaunch(
                                                'https://smartsewa.com.np/privacy-policy');
                                          },
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              value: isChecked,
                              onChanged: (newValue) {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                              visualDensity: VisualDensity.compact,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                            SizedBox(height: size.height * 0.025),
                            AppButton(
                              name: 'Register',
                              isDisabled: !isChecked,
                              onPressed: () async {
                                var connectivityResult =
                                    await (Connectivity().checkConnectivity());
                                if (connectivityResult ==
                                    ConnectivityResult.none) {
                                  errorToast(msg: 'No Internet');
                                  return;
                                }
                                if (_formkey.currentState!.validate() &&
                                    selectedLatLng.value != null) {
                                  CustomDialogs.fullLoadingDialog(
                                      data: "Loading...", context: context);
                                  controller
                                      .checkNumberAndEmailRegister(
                                          email: _emailController.text,
                                          mobileNumber: _phoneController.text)
                                      .then((value) {
                                    Get.back();
                                    if (value == true) {
                                      _randomNumber =
                                          Random().nextInt(90000) + 10000;
                                      controller.sendOTP(
                                        message:
                                            """Thank you for registering your account. Your OTP verification code is""",
                                        phoneNumber: _phoneController.text,
                                        randomNumber: _randomNumber,
                                      );
                                      Get.to(() => RegisterOtp(
                                            number: _randomNumber,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                            firstName:
                                                _firstnameController.text,
                                            lastName: _lastnameController.text,
                                            phone: _phoneController.text,
                                            latitude: selectedLatLng
                                                    .value?.latitude
                                                    .toString() ??
                                                "",
                                            longitude: selectedLatLng
                                                    .value?.longitude
                                                    .toString() ??
                                                "",
                                          ));
                                    } else {
                                      errorToast(
                                          msg:
                                              "Mobile number or Email is already in use !!");
                                    }
                                  });
                                } else {
                                  CustomSnackBar.showSnackBar(
                                      title: "Please fill", color: Colors.red);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => widget.mapController.isMapLoading.value
                  ? const OverlayedLoadingScreen()
                  : const SizedBox(),
            ),
          ],
        ),
      ),
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

  Position? position;

  ///*******Code For Google Map*******//////
  // bool onpressed = false;
  final Completer<GoogleMapController> _controller = Completer();
  // final LatLng _selectedLatLng = const LatLng(27.707795, 85.343362);
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
              position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
              Get.to(() => OpenMapScreen(
                    completeGoogleMapController: completeGoogleMapController,
                    kGoogle: kGoogle,
                    marker: marker,
                    onpressed: onpressed,
                  ));
            }

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
          builder: (BuildContext context, dynamic value, Widget? child) {
            return Text(
              "Address: ${selectedLatLng.value}",
              style: const TextStyle(
                fontFamily: 'hello',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black38,
              ),
            );
          },
        ),
      ],
    );
  }

  // openMap() {
  //   Size size = MediaQuery.of(context).size;
  //   return SafeArea(
  //     child: Column(
  //       children: [
  //         // const SizedBox(height: 100),
  //         Expanded(
  //           // height: size.height * 0.88,
  //           // width: 500,
  //           // color: Colors.red,
  //           child: GoogleMap(
  //             initialCameraPosition: _kGoogle,
  //             markers: Set<Marker>.of(_marker),
  //             mapType: MapType.normal,
  //             myLocationEnabled: true,
  //             compassEnabled: true,
  //             onMapCreated: (GoogleMapController controller) {
  //               _controller.complete(controller);
  //             },
  //             onTap: (LatLng latLng) {
  //               setState(() {
  //                 _selectedLatLng = latLng;
  //                 _marker.clear();
  //                 _marker.add(
  //                   Marker(
  //                     markerId: const MarkerId('Selected Location'),
  //                     position: _selectedLatLng,
  //                     infoWindow: InfoWindow(
  //                       title: _selectedLatLng.toString(),
  //                     ),
  //                   ),
  //                 );
  //               });
  //             },
  //             // onTap: (LatLng latLng) {
  //             //   setState(
  //             //     () {
  //             //       _selectedLatLng = latLng;
  //             //     },
  //             //   );
  //             // },
  //             // initialCameraPosition: currentLocation != null
  //             //     ? CameraPosition(
  //             //         target: LatLng(
  //             //           currentLocation!.latitude!,
  //             //           currentLocation!.longitude!,
  //             //         ),
  //             //         zoom: 14,
  //             //       )
  //             //     : const CameraPosition(
  //             //         target: LatLng(27.706969, 85.341963),
  //             //         zoom: 14,
  //             //       ),
  //             // initialCameraPosition: CameraPosition(
  //             //   target: _selectedLatLng,
  //             //   zoom: 14,
  //             // ),
  //             // ignore: unnecessary_null_comparison
  //             // markers: _selectedLatLng != null
  //             //     ? {
  //             //         Marker(
  //             //             markerId: const MarkerId('Selected Location'),
  //             //             position: _selectedLatLng,
  //             //             infoWindow:
  //             //                 InfoWindow(title: _selectedLatLng.toString())),
  //             //       }
  //             //     : {},
  //           ),
  //         ),
  //         Container(
  //           height: 50,
  //           width: double.infinity,
  //           color: Theme.of(context).primaryColor,
  //           child: Align(
  //             alignment: Alignment.bottomRight,
  //             child: Padding(
  //               padding: const EdgeInsets.only(right: 8.0),
  //               child: TextButton(
  //                 style: ButtonStyle(
  //                     shape: MaterialStatePropertyAll(RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8))),
  //                     backgroundColor:
  //                         const MaterialStatePropertyAll(Colors.blue)),
  //                 child: const Text(
  //                   'Ok',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   setState(() {
  //                     onpressed = false;
  //                   });
  //                 },
  //               ),
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  ///***Api hit for sms ***///
  String apiKey = 'v2_aDW1PIhMnzH79EeoyWAn6tH3gFt.K7aZ'; //token generated
  // from sms service provider
  String url = 'https://api.sparrowsms.com/v2/sms/'; // Base url for sms
  // service ,provided by sms provider
  Future<void> _sendOTP() async {
    var response = await http.post(
      Uri.parse(url),
      body: {
        'token': apiKey,
        'to': _phoneController.text,
        'from': "Demo",
        'text': "Otp verification code : $_randomNumber",
      },
    );
    logger(response.body, loggerType: LoggerType.success);
    if (response.statusCode == 200) {
      // Get.to(() => RegisterOtp(
      //       number: _randomNumber,
      //       email: _emailController.text,
      //       password: _passwordController.text,
      //       firstName: _firstnameController.text,
      //       lastName: _lastnameController.text,
      //       phone: _phoneController.text,
      //     ));
    }
  }
}
