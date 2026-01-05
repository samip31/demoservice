// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartsewa/core/development/console.dart';

import '../../../core/states.dart';
import '../../widgets/my_appbar.dart';
import 'package:geocoding/geocoding.dart';

import 'map_controller.dart';

class OpenMapScreen extends StatefulWidget {
  GoogleMapController? googleMapController;
  final mapController = Get.put(MapController());
  Completer<GoogleMapController> completeGoogleMapController;

  CameraPosition kGoogle;
  final List<Marker> marker;
  bool onpressed;
  OpenMapScreen({
    Key? key,
    this.googleMapController,
    required this.completeGoogleMapController,
    required this.kGoogle,
    required this.onpressed,
    required this.marker,
  }) : super(key: key);

  @override
  State<OpenMapScreen> createState() => _OpenMapScreenState();
}

class _OpenMapScreenState extends State<OpenMapScreen> {
  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
    // initialGeo();
  }

  LocationPermission? permission;
  Position? position;

  Future<Position?> getUserCurrentLocation() async {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
    } else if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('permission allowed');
      if (position != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position!.latitude, position!.longitude);

        return await Geolocator.getCurrentPosition();
      }
    }
    return null;
    // await Geolocator.requestPermission().then((value) async {
    //   return await Geolocator.getCurrentPosition();
    // }).onError((error, stackTrace) async {
    //   logger(error, loggerType: LoggerType.error);
    //   await Geolocator.requestPermission();
    //   CustomSnackBar.showSnackBar(
    //       title: "Permission denied", color: Colors.red);
    //   return await Geolocator.getCurrentPosition();
    // });
    // return await Geolocator.getCurrentPosition();
  }

  initialGeo() async {
    getUserCurrentLocation().then((value) async {
      // print("${value.latitude} ${value.longitude}");
      // // marker added for current users location
      // _marker.add(Marker(
      //   markerId: const MarkerId("2"),
      //   position: LatLng(value.latitude, value.longitude),
      //   infoWindow: const InfoWindow(
      //     title: 'My Current Location',
      //   ),
      // ));

      // specified current users location
      // CameraPosition cameraPosition = CameraPosition(
      //   target: LatLng(value.latitude, value.longitude),
      //   zoom: 14,
      // );
      await widget.completeGoogleMapController.future
          .then((val) => val.animateCamera(CameraUpdate.newLatLngZoom(
                LatLng(value!.latitude, value.longitude),
                18.0,
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        selectedLatLng.value = null;
        return true;
      },
      child: Scaffold(
        appBar: myAppbar(
          context,
          false,
          "",
          leading: GestureDetector(
            onTap: () {
              selectedLatLng.value = null;
              Get.back();
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            // const SizedBox(height: 100),
            Expanded(
              // height: size.height * 0.795,
              // width: 500,
              // color: Colors.red,
              child: GoogleMap(
                initialCameraPosition: widget.kGoogle,
                markers: Set<Marker>.of(widget.marker),
                mapType: MapType.normal,
                myLocationEnabled: true,
                // minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                compassEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  widget.mapController.isMapLoading.value = false;
                  if (!widget.completeGoogleMapController.isCompleted) {
                    widget.completeGoogleMapController.complete(controller);
                  }
                },
                onTap: (LatLng latLng) {
                  setState(() {
                    selectedLatLng.value = latLng;
                    widget.marker.clear();
                    widget.marker.add(
                      Marker(
                        markerId: const MarkerId('Selected Location'),
                        position: selectedLatLng.value ??
                            const LatLng(27.707795, 85.343362),
                        infoWindow: InfoWindow(
                          title: selectedLatLng.value.toString(),
                        ),
                      ),
                    );
                  });
                  consolelog(selectedLatLng.value.toString());
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
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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
                        widget.onpressed = false;
                      });
                      Get.back();
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
