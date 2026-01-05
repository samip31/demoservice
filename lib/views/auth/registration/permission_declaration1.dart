import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smartsewa/views/widgets/buttons/app_buttons.dart';

import '../../user_screen/approval/open_map_screen.dart';



class PermissionDeclaration1 extends StatelessWidget {


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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10.0),
          children: [
            Text('Use your Location',textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
            SizedBox(height: 18.0,),
            Text('To see maps for automatically tracked activities allow Smart Sewa to use your locaton all of the time', textAlign: TextAlign.center, style: TextStyle(fontSize: 18,)),
            SizedBox(height: 16.0,),
            Text('We need your location to show matching locations of Service Providers.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18,)),
            SizedBox(height: 20.0,),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey.withOpacity(0.5))
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset('assets/location.png'))),
            SizedBox(height: 16.0,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
                onPressed: (){Navigator.of(context).pop();},
                child: Text('Deny', style: TextStyle(fontSize: 18))),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: (){
                  Get.off(
                          () => OpenMapScreen(
                        completeGoogleMapController: completeGoogleMapController,
                        kGoogle: kGoogle,
                        marker: marker,
                        onpressed: onpressed,
                      ));

                }, child: Text('Accept', style: TextStyle(fontSize: 18),))
          ],
        ),
      ),
    );
  }
}
