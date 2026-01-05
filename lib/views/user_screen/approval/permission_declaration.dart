import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../widgets/ovelayed_loading_screen.dart';
import 'map_controller.dart';
import 'open_map_screen.dart';

class PermissionDeclaration extends StatelessWidget {
  bool onpressed = false;
  final mapController = Get.put(MapController());
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

  PermissionDeclaration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
              children: [
                const Text(
                  'Use your Location',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 18.0,
                ),
                const Text(
                    'To see maps for automatically tracked activities allow Smart Sewa to use your locaton all of the time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    )),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                    'We need your location to show your location to users for them to select according to their locations.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    )),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border:
                            Border.all(color: Colors.grey.withOpacity(0.5))),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.asset('assets/location.png'))),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Get.snackbar(
                        'Permission Denied',
                        'Please allow location permission to select your location.',
                      );
                    },
                    child: const Text('Deny', style: TextStyle(fontSize: 18))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () async {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.deniedForever) {
                        await Geolocator.openAppSettings();
                      } else if (permission != LocationPermission.denied &&
                          permission != LocationPermission.deniedForever) {
                        mapController.isMapLoading.value = true;
                        Get.off(() => OpenMapScreen(
                              completeGoogleMapController:
                                  completeGoogleMapController,
                              kGoogle: kGoogle,
                              marker: marker,
                              onpressed: onpressed,
                            ));
                      }
                    },
                    child: const Text(
                      'Accept',
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            ),
            Obx(
              () => mapController.isMapLoading.value
                  ? const OverlayedLoadingScreen()
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
