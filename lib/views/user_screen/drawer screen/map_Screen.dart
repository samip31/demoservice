import 'dart:async';
import 'dart:developer';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/models/service_map_model.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/network/services/categories&services/service_map_controller.dart';
import 'package:smartsewa/network/services/orderService/filter_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../network/base_client.dart';
import '../../../network/services/orderService/request_service.dart';
import '../../Theme/theme.dart';
import '../../widgets/my_appbar.dart';

class MapScreen extends StatefulWidget {
  final String work;
  final String name;

  const MapScreen({Key? key, required this.work, required this.name})
      : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  String baseUrl = BaseClient().baseUrl;
  var isLoading = false.obs;
  final myMapController = Get.put(MyMapController());
  final controller = Get.put(OrderController());
  final authController = Get.put(AuthController());
  final filterController = Get.put(FilterController());
  double averageRating = 0.0;
  String? token;
  final Completer<GoogleMapController> _controller = Completer();
  int? tid;
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

  @override
  void initState() {
    getToken();
    _getUserLocation();

    super.initState();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  List<ServiceMapModel> getWorker() {
    return myMapController.users
        .where((user) =>
            user.serviceProvided.toLowerCase() == widget.work.toLowerCase() &&
            user.id != tid)
        .toList();
  }

  LatLng currentPostion = const LatLng(27.709290, 85.348101);

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
    });
  }

  Future<double> fetchAverageRating(int id) async {
    isLoading.value = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    log('this is service id:$id');

    try {
      final url = '$baseUrl/api/v1/rating/average-rating/$id';
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer $apptoken"
        },
      );

      if (response.statusCode == 200) {
        final rating = double.parse(response.body);

        // setState(() {
        //   averageRating = rating;
        // });
        log('This is rating:$rating');
        return rating;
      }
    } catch (error) {
      log('This is error:$error');
    } finally {
      isLoading.value = false;
    }
    return 0.0;
  }

  Future<void> getUserId(int id) async {
    double rating = await fetchAverageRating(id);
    setState(() {
      averageRating = rating;
    });
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    setState(() {
      token = apptoken;
      tid = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    debugPrint("on Map Screen after clicking services");
    return Scaffold(
      appBar: myAppbar(context, true, widget.name),
      body: Obx(() {
        // if (myMapController.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // } else {
        final markers = getWorker()
            .map(
              (user) => Marker(
                markerId: MarkerId(user.id.toString()),
                position: LatLng(
                  double.parse(user.latitude),
                  double.parse(user.longitude),
                ),
                onTap: () async {
                  double averageRating = await fetchAverageRating(user.id);
                  debugPrint("ontap");
                  _customInfoWindowController.addInfoWindow!(
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          Container(
                            padding: const EdgeInsets.all(8),
                            height: 270,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(38),
                                    topLeft: Radius.circular(38))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        "$baseUrl/api/allimg/image/${user.picture}",
                                        headers: {
                                          'Authorization': "Bearer $token",
                                        },
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${user.firstName} ${user.lastName}",
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            RatingBarIndicator(
                                              rating: averageRating,
                                              itemSize: 30.0,
                                              itemBuilder: (context, index) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Text(
                                              averageRating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              ),
                                            )
                                          ],
                                        )

                                        // Text(
                                        //   "${user.id}",
                                        //   style: const TextStyle(
                                        //     fontSize: 18,
                                        //     fontWeight: FontWeight.w500,
                                        //     color: Colors.black,
                                        //   ),
                                        // )
                                      ],
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: Colors.black54,
                                  height: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Job Title : ${user.serviceProvided}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                      'Job Field : ${user.jobfield}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Contact : ${user.mobileNumber}',
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          height: 44,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.green),
                                              onPressed: () async {
                                                final Uri url = Uri(
                                                  scheme: 'tel',
                                                  path: "${user.mobileNumber}",
                                                );
                                                if (await canLaunchUrl(url)) {
                                                  await launchUrl(url);
                                                } else {
                                                  debugPrint(
                                                      'Cannot launch this url');
                                                }
                                              },
                                              child: const Text(
                                                'Call',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Can I get your Service',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Center(
                                      child: SizedBox(
                                        height: 44,
                                        width: 150,
                                        child: ElevatedButton(
                                            style: const ButtonStyle(
                                                padding:
                                                    MaterialStatePropertyAll(
                                                        EdgeInsets.all(12)),
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.red)),
                                            child: const Text(
                                              "Request",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Get.defaultDialog(
                                                  title: 'Confirmation',
                                                  middleText:
                                                      'Do you want to proceed?',
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        controller
                                                            .requestService(
                                                                user.id);
                                                      },
                                                      child: const Text('Yes'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: const Text('No'),
                                                    ),
                                                  ]);
                                            }),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.companyName.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                "${user.firstName} ${user.lastName}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "View Details",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: MyTheme().appTheme().primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    LatLng(
                      double.parse(user.latitude),
                      double.parse(user.longitude),
                    ),
                  );
                  // ignore: use_build_context_synchronously
                },
              ),
            )
            .toSet();

        return myMapController.isMapLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _kGoogle,
                    // markers: Set<Marker>.of(_marker),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _customInfoWindowController.googleMapController =
                          controller;
                    },
                    onTap: (position) {
                      debugPrint(
                          "hide info window after click outside it anywhere");
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    // onCameraMove: (position) {
                    //   debugPrint(
                    //       "camera is moving, hide info window first before moving");
                    //   _customInfoWindowController.hideInfoWindow!();
                    // },
                    onCameraMoveStarted: () {
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    onLongPress: (position) {
                      debugPrint(
                          "hide info window after click outside it anywhere");
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    // initialCameraPosition: CameraPosition(
                    //   target: currentPostion,
                    //   zoom: 14,
                    // ),

                    markers: markers,
                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: 88,
                    width: 130,
                  ),
                  // isLoading.value
                  //     ? Container(
                  //         height: MediaQuery.of(context).size.height,
                  //         width: double.infinity,
                  //         decoration: const BoxDecoration(
                  //           color: Color.fromARGB(183, 0, 0, 0),
                  //         ),
                  //         child: const Center(
                  //           child: CircularProgressIndicator(),
                  //         ),
                  //       )
                  //     : const SizedBox(),
                ],
              );
        // }
      }),
    );
  }
}





// class MapScreen extends StatefulWidget {
//   final String work;
//   final String name;

//   const MapScreen({Key? key, required this.work, required this.name})
//       : super(key: key);

//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   final myMapController = Get.put(MyMapController());
//   final controller = Get.put(OrderController());
//   final authController = Get.put(AuthController());
//   final filterController = Get.put(FilterController());
//   double averageRating = 0.0;
//   String? token;
//   final Completer<GoogleMapController> _controller = Completer();
//   int? tid;
//   static const CameraPosition _kGoogle = CameraPosition(
//     target: LatLng(27.707795, 85.343362),
//     zoom: 14.4746,
//   );
//   final List<Marker> _marker = <Marker>[
//     // const Marker(
//     //     markerId: MarkerId('1'),
//     //     position: LatLng(27.707795, 85.343362),
//     //     infoWindow: InfoWindow(
//     //       title: 'My Position',
//     //     )),
//   ];
//   Future<Position> getUserCurrentLocation() async {
//     await Geolocator.requestPermission()
//         .then((value) {})
//         .onError((error, stackTrace) async {
//       await Geolocator.requestPermission();
//       print("ERROR$error");
//     });
//     return await Geolocator.getCurrentPosition();
//   }

//   List<ServiceMapModel> getWorker() {
//     return myMapController.users
//         .where((user) =>
//             user.serviceProvided.toLowerCase() == widget.work.toLowerCase() &&
//             user.id != tid)
//         .toList();
//   }

//   LatLng currentPostion = const LatLng(27.709290, 85.348101);

//   void _getUserLocation() async {
//     var position = await GeolocatorPlatform.instance.getCurrentPosition();
//     setState(() {
//       currentPostion = LatLng(position.latitude, position.longitude);
//     });
//   }

//   @override
//   void initState() {
//     getToken();
//     _getUserLocation();

//     super.initState();
//   }

//   Future<double> fetchAverageRating(int id) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? apptoken = prefs.getString("token");
//     log('this is service id:$id');

//     final url = 'http://13.232.92.169:9000/api/v1/rating/average-rating/$id';
//     final response = await http.get(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': "Bearer $apptoken"
//       },
//     );

//     if (response.statusCode == 200) {
//       final rating = double.parse(response.body);

//       // setState(() {
//       //   averageRating = rating;
//       // });
//       log('This is rating:$rating');
//       return rating;
//     } else {
//       // Handle error case
//       print('Failed to fetch average rating: ${response.statusCode}');
//     }
//     return 0.0;
//   }

//   Future<void> getUserId(int id) async {
//     double rating = await fetchAverageRating(id);
//     setState(() {
//       averageRating = rating;
//     });
//   }

//   void getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? apptoken = prefs.getString("token");
//     int? id = prefs.getInt("id");
//     setState(() {
//       token = apptoken;
//       tid = id;
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       appBar: myAppbar(context, true, widget.name),
//       body: Obx(() {
//         if (myMapController.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           final markers = getWorker()
//               .map((user) => Marker(
//                     markerId: MarkerId(user.id.toString()),
//                     position: LatLng(
//                       double.parse(user.latitude),
//                       double.parse(user.longitude),
//                     ),
//                     infoWindow: InfoWindow(
//                       title: user.companyName.toString(),
//                       snippet: "${user.firstName} ${user.lastName}",
//                       onTap: () async {
//                         double averageRating =
//                             await fetchAverageRating(user.id);
//                         // ignore: use_build_context_synchronously
//                         MyDialogs().myAlert(context, "Check Details",
//                             "Do you want to see details?", () {
//                           Get.back();
//                         }, () {
//                           Get.back();
//                           Get.bottomSheet(Container(
//                             padding: const EdgeInsets.all(8),
//                             height: 265,
//                             width: double.infinity,
//                             decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(38),
//                                     topLeft: Radius.circular(38))),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     CircleAvatar(
//                                       radius: 40,
//                                       backgroundImage: NetworkImage(
//                                         "http://13.232.92.169:9000/api/allimg/image/${user.picture}",
//                                         headers: {
//                                           'Authorization': "Bearer $token",
//                                         },
//                                       ),
//                                       backgroundColor: Colors.blue,
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "${user.firstName} ${user.lastName}",
//                                           style: const TextStyle(
//                                             fontSize: 24,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         Row(
//                                           children: [
//                                             RatingBarIndicator(
//                                               rating: averageRating,
//                                               itemSize: 30.0,
//                                               itemBuilder: (context, index) =>
//                                                   const Icon(
//                                                 Icons.star,
//                                                 color: Colors.amber,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: size.width * 0.02,
//                                             ),
//                                             Text(
//                                               averageRating.toStringAsFixed(1),
//                                               style: const TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.grey,
//                                               ),
//                                             )
//                                           ],
//                                         )

//                                         // Text(
//                                         //   "${user.id}",
//                                         //   style: const TextStyle(
//                                         //     fontSize: 18,
//                                         //     fontWeight: FontWeight.w500,
//                                         //     color: Colors.black,
//                                         //   ),
//                                         // )
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                                 const Divider(
//                                   color: Colors.black54,
//                                   height: 15,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Job Title : ${user.serviceProvided}',
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: size.height * 0.01,
//                                     ),
//                                     Text(
//                                       'Job Field : ${user.jobfield}',
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w500,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           'Contact : ${user.mobileNumber}',
//                                           overflow: TextOverflow.clip,
//                                           style: const TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         ElevatedButton(
//                                             style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Colors.green),
//                                             onPressed: () async {
//                                               final Uri url = Uri(
//                                                 scheme: 'tel',
//                                                 path: "${user.mobileNumber}",
//                                               );
//                                               if (await canLaunchUrl(url)) {
//                                                 await launchUrl(url);
//                                               } else {
//                                                 print('Cannot launch this url');
//                                               }
//                                             },
//                                             child: const Text('Call'))
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Center(
//                                   child: ElevatedButton(
//                                       style: const ButtonStyle(
//                                           padding: MaterialStatePropertyAll(
//                                               EdgeInsets.all(12)),
//                                           backgroundColor:
//                                               MaterialStatePropertyAll(
//                                                   Colors.red)),
//                                       child: const Text(
//                                         "Request",
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       onPressed: () {
//                                         Get.defaultDialog(
//                                             title: 'Confirmation',
//                                             middleText:
//                                                 'Do you want to proceed?',
//                                             actions: [
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   controller
//                                                       .requestService(user.id);
//                                                 },
//                                                 child: const Text('Yes'),
//                                               ),
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   Get.back();
//                                                 },
//                                                 child: const Text('No'),
//                                               ),
//                                             ]);
//                                       }),
//                                 )
//                               ],
//                             ),
//                           ));
//                         });
//                       },
//                     ),
//                   ))
//               .toSet();
//           return GoogleMap(
//             initialCameraPosition: _kGoogle,
//             // markers: Set<Marker>.of(_marker),
//             mapType: MapType.normal,
//             myLocationEnabled: true,
//             compassEnabled: true,
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//             },
//             // initialCameraPosition: CameraPosition(
//             //   target: currentPostion,
//             //   zoom: 14,
//             // ),
//             markers: markers,
//           );
//         }
//       }),
//     );
//   }
// }

