import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/services/categories&services/categories_controller.dart';
import 'package:smartsewa/network/services/categories&services/service_controller.dart';
import 'package:smartsewa/network/services/image_services/image_controller.dart';
import 'package:smartsewa/network/services/notification_services/notification_controller.dart';
import 'package:smartsewa/utils/double_tap_back.dart';
import 'package:smartsewa/utils/string_extension.dart';
import 'package:smartsewa/views/connection.dart';
import 'package:smartsewa/views/user_screen/categories/services.dart';

import 'package:smartsewa/views/user_screen/setting/setting.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/offer.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/market_place_screen.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/vacancy.dart';
import '../../network/services/banner_repo/banner_repo.dart';
import '../../network/services/orderService/filter_controller.dart';
import '../../network/services/userdetails/current_user_controller.dart';
import '../widgets/custom_toasts.dart';
import '../widgets/my_drawer.dart';
import 'notification.dart';
import 'profile/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  final indexes = 0;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final int myTime = 3;

  final List<String> topImages = [
    "1_banner_TopImg1.png",
    "1_banner_TopImg2.png",
    "1_banner_TopImg3.png",
    "1_banner_TopImg4.png",
  ];
  final List<String> bottomImages = [
    "1_banner_BottomImg1.png",
    "1_banner_BottomImg2.png",
    "1_banner_BottomImg3.png",
    "1_banner_BottomImg4.png"
  ];

  // final List<String> myImages = [
  //   ("assets/services_images/electrical.png"),
  //   ("assets/services_images/plumbing.png"),
  //   ("assets/services_images/masonry_works.png"),
  //   ("assets/services_images/cleaning.png"),
  //   ("assets/services_images/carpentry.png"),
  //   ("assets/services_images/metal_works.png"),
  //   ("assets/services_images/paint_and_painting.png"),
  //   ("assets/services_images/cook_and_waiter.png"),
  //   ("assets/services_images/home_care_staff.png"),
  //   ("assets/services_images/healthcare_and_medicine.png"),
  //   ("assets/services_images/veterinary_and_pet_care.png"),
  //   ("assets/services_images/tution_and_languages.png"),
  //   ("assets/services_images/music_and_dance.png"),
  //   ("assets/services_images/garderner_and_agriculture_works.png"),
  //   ("assets/services_images/catering_and_rent.png"),
  //   ("assets/services_images/event_and_party.png"),
  //   ("assets/services_images/furniture_and_homedecor.png"),
  //   ("assets/services_images/air_and_travels.png"),
  //   ("assets/services_images/vehicle.png"),
  //   ("assets/services_images/fitness_and_yoga.png"),
  //   ("assets/services_images/waste_management.png"),
  //   ("assets/services_images/trainning_and_skill_program.png"),
  //   ("assets/services_images/office_staff.png"),
  //   ("assets/services_images/advertisement_and_promotion.png"),
  //   ("assets/services_images/printing_and_press.png"),
  //   ("assets/services_images/books_and_stationery.png"),
  //   ("assets/services_images/engineering.png"),
  //   ("assets/services_images/dharmik_karyakram.png"),
  //   ("assets/services_images/others.png"),
  // ];

  final int _currentIndex = 0;
  late List<Widget> screens;

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  // final filterController = Get.put(FilterController());
  // final serController = Get.put(ServicesController());
  // final imageController = Get.put(ImageController());
  // final catController = Get.put(CatController());

  final controller = Get.put(CurrentUserController());
  final notificationsController = Get.put(NotificationController());
  final BannerImageController bannerController =
      Get.put(BannerImageController());

  File? image;

  String? token;

  int index = 0;
  final scrollController = ScrollController();
  final homeScreenKey = GlobalKey();
  List<dynamic> notifications = [];
  @override
  void initState() {
    super.initState();
    getToken();
    controller.getCurrentUser();
    // bannerController.loadImagesFromSharedPreferences();

    bannerController.loadImagesFromSharedPreferences().then((_) {
      if (bannerController.topBanners.isEmpty ||
          bannerController.bottomBanners.isEmpty) {
        // If either of them is empty, fetch images
        bannerController.fetchImages();
      }

      // Debugging: Print whether savedTopBanners and savedBottomBanners are empty
      print('savedTopBanners is empty: ${bannerController.topBanners.isEmpty}');
      print(
          'savedBottomBanners is empty: ${bannerController.bottomBanners.isEmpty}');
    });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   controller.getCurrentUser();
    // });

    // imageController.fetchImages(controller.currentUserData.value.picture);
    //
    // catController.getCategories();
    // serController.fetchServices();
    // notificationsController.fetchUserNotificationsSeenStatus();

    // notificationsController.fetchUserNotifications().then((data) {
    //   setState(() {
    //     notifications = data!;
    //   });
    // }).catchError((error) {
    //   print(error);
    // });
  }

  void listenScrolling() {
    if (scrollController.position.atEdge) {
      final isTop = scrollController.position.pixels == 0;

      if (isTop) {}
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    controller.getCurrentUser();
    // imageController.fetchImages(controller.currentUserData.value.picture);
    // catController.getCategories();
    // serController.fetchServices();
    notificationsController.fetchUserNotificationsSeenStatus();
    notificationsController.fetchAdminNotification();
  }

  // getPicture() async {
  //   await controller.getCurrentUser();
  // }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    // int? tid = prefs.getInt("id");
    setState(() {
      token = apptoken;
    });
  }

  void scrollUp() {
    // const double start = 0;
    // scrollController.jumpTo(start);
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    _refreshData();
  }

  String baseUrl = BaseClient().baseUrl;

  final List<Service> myServices = [
    Service(1, "Electrical", "assets/services_images/electrical.png"),
    Service(2, "Plumbing", "assets/services_images/plumbing.png"),
    Service(3, "Masonry Works", "assets/services_images/masonry_works.png"),
    Service(4, "Cleaning", "assets/services_images/cleaning.png"),
    Service(5, "Carpentry", "assets/services_images/carpentry.png"),
    Service(6, "Metal Works", "assets/services_images/metal_works.png"),
    Service(7, "Paint and Painting",
        "assets/services_images/paint_and_painting.png"),
    Service(8, "Cook and Waiter", "assets/services_images/cook_and_waiter.png"),
    Service(9, "Home Care Staff", "assets/services_images/home_care_staff.png"),
    Service(10, "Healthcare and Medicine",
        "assets/services_images/healthcare_and_medicine.png"),
    Service(11, "Veterinary and Pet Care",
        "assets/services_images/veterinary_and_pet_care.png"),
    Service(12, "Tuition and Languages",
        "assets/services_images/tution_and_languages.png"),
    Service(
        13, "Music and Dance", "assets/services_images/music_and_dance.png"),
    Service(14, "Gardener and Agriculture Works",
        "assets/services_images/garderner_and_agriculture_works.png"),
    Service(15, "Catering and Rent",
        "assets/services_images/catering_and_rent.png"),
    Service(
        16, "Event and Party", "assets/services_images/event_and_party.png"),
    Service(17, "Furniture and Home Decor",
        "assets/services_images/furniture_and_homedecor.png"),
    Service(
        18, "Travel and Tours", "assets/services_images/air_and_travels.png"),
    Service(19, "Vehicle", "assets/services_images/vehicle.png"),
    Service(
        20, "Fitness and Yoga", "assets/services_images/fitness_and_yoga.png"),
    Service(
        21, "Waste Management", "assets/services_images/waste_management.png"),
    Service(22, "Training and Skill Program",
        "assets/services_images/trainning_and_skill_program.png"),
    Service(23, "Office Staff", "assets/services_images/office_staff.png"),
    Service(24, "Advertisement and Promotion",
        "assets/services_images/advertisement_and_promotion.png"),
    Service(25, "Printing and Press",
        "assets/services_images/printing_and_press.png"),
    Service(26, "Books and Stationery",
        "assets/services_images/books_and_stationery.png"),
    Service(27, "Engineering", "assets/services_images/engineering.png"),
    Service(28, "Dharmik Karyakram",
        "assets/services_images/dharmik_karyakram.png"),
    Service(29, "Many More", "assets/services_images/others.png"),
  ];

  @override
  Widget build(BuildContext context) {
    // console("token $token");
    // consolelog("this is picture : ${controller.picture}");

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: OfflineBuilder(
          connectivityBuilder: (BuildContext context,
              ConnectivityResult connectivity, Widget child) {
            final bool connected = connectivity != ConnectivityResult.none ||
                connectivity != ConnectivityResult.other;
            if (connected) {
              // _refreshData();
              return Scaffold(
                key: _scaffoldState,
                drawer: myDrawer(context),
                drawerEdgeDragWidth: 150,
                body: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView(
                        controller: scrollController,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _scaffoldState.currentState!.openDrawer();
                                    },
                                    icon: Icon(
                                      Icons.menu,
                                      size: 35,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  Expanded(
                                    child: Text(
                                      "${controller.currentUserData.value.firstName?.toUppercaseFirstLetter()} ${controller.currentUserData.value.lastName?.toUppercaseFirstLetter()}",
                                      // "${controller.fullName}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => const Profile());
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundImage: NetworkImage(
                                        "$baseUrl/api/allimg/image/${controller.currentUserData.value.picture}",
                                        // "${BaseClient().baseUrl}/api/allimg/image/${controller.picture}",
                                        headers: {
                                          'Authorization': "Bearer $token"
                                        },
                                      ),
                                      radius: 15,
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.03),
                                  Stack(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.to(() => NotificationScreen(
                                                notifications: const [],
                                              ));
                                        },
                                        icon: Icon(
                                          Icons.notifications,
                                          size: 30,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      notificationsController.seenStatus.value
                                          ? Container()
                                          : Positioned(
                                              right: 9,
                                              top: 8,
                                              child: Container(
                                                width: 10,
                                                height: 10,
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Get.to(() => const SettingPage());
                                    },
                                    icon: Icon(
                                      Icons.settings,
                                      size: 30,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.aspectRatio * 40,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () {
                                        final sharedPreferenceTopBanner =
                                            bannerController.topBanners;
                                        if (sharedPreferenceTopBanner.isEmpty) {
                                          return CarouselSlider(
                                            items: [
                                              Image.asset('assets/Logo.png'),
                                            ],
                                            options: CarouselOptions(
                                              autoPlay: true,
                                              enlargeCenterPage: true,
                                              aspectRatio: 16 / 9,
                                            ),
                                          );
                                        } else {
                                          return CarouselSlider.builder(
                                            itemCount: sharedPreferenceTopBanner
                                                .length,
                                            options: CarouselOptions(
                                              enableInfiniteScroll: false,
                                              autoPlay: true,
                                              enlargeCenterPage: true,
                                              aspectRatio: 16 / 9,
                                            ),
                                            itemBuilder:
                                                (context, index, realIndex) {
                                              final imageUrl =
                                                  sharedPreferenceTopBanner[
                                                      index];
                                              return Image.network(imageUrl);
                                            },
                                          );
                                        }
                                      },
                                    ),
                                    // Obx(
                                    //       () {
                                    //     final savedTopBanners = bannerController.topBanners;
                                    //
                                    //
                                    //
                                    //     if (savedTopBanners.isEmpty) {
                                    //       // Fetch images from the server when savedTopBanners is empty
                                    //       bannerController.fetchImages();
                                    //       return CircularProgressIndicator();
                                    //     } else {
                                    //       // Display saved topBanners from SharedPreferences
                                    //       return CarouselSlider.builder(
                                    //         itemCount: savedTopBanners.length,
                                    //         options: CarouselOptions(
                                    //           enableInfiniteScroll: false,
                                    //           autoPlay: true,
                                    //           enlargeCenterPage: true,
                                    //           aspectRatio: 16 / 9,
                                    //         ),
                                    //         itemBuilder: (context, index, realIndex) {
                                    //           final imageUrl = savedTopBanners[index];
                                    //           return Image.network(imageUrl);
                                    //         },
                                    //       );
                                    //     }
                                    //   },
                                    // )

                                    SizedBox(height: size.height * 0.01),
                                    Container(
                                      width: double.infinity,
                                      padding:
                                          EdgeInsets.all(size.aspectRatio * 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          buildContainer(
                                            context,
                                            "Market",
                                            () {
                                              Get.to(
                                                () => const MarketPlaceScreen(),
                                              );
                                            },
                                            "assets/market.png",
                                          ),
                                          buildContainer(
                                            context,
                                            "Vacancy",
                                            () {
                                              Get.to(
                                                () => const Vacancy(),
                                              );
                                            },
                                            'assets/vacancy.png',
                                          ),
                                          buildContainer(
                                            context,
                                            "Offer",
                                            () {
                                              Get.to(
                                                () => const OfferScreen(),
                                              );
                                            },
                                            'assets/offer_sale.png',
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.03),
                                    const Text(
                                      'Our Services',
                                      style: TextStyle(
                                        fontFamily: 'hello',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 24,
                                      ),
                                      // height: size.height * 1.48,
                                      width: double.infinity,
                                      child: categories(),
                                    ),
                                    vSizedBox2,
                                    Obx(
                                      () {
                                        final savedBottomBanners =
                                            bannerController.bottomBanners;
                                        if (savedBottomBanners.isEmpty) {
                                          return CarouselSlider(
                                            items: [
                                              Image.asset('assets/Logo.png'),
                                            ],
                                            options: CarouselOptions(
                                              autoPlay: true,
                                              enlargeCenterPage: true,
                                              aspectRatio: 16 / 9,
                                            ),
                                          );
                                        }
                                        return CarouselSlider.builder(
                                          itemCount: savedBottomBanners.length,
                                          options: CarouselOptions(
                                            enableInfiniteScroll: false,
                                            autoPlay: true,
                                            enlargeCenterPage: true,
                                            aspectRatio: 16 / 9,
                                          ),
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            final imageUrl =
                                                savedBottomBanners[index];
                                            return Image.network(imageUrl);
                                          },
                                        );
                                      },
                                    )
                                    // SizedBox(height: size.height * 0.03),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                }),
                bottomNavigationBar: BottomAppBar(
                  color: Colors.black,
                  child: InkWell(
                    onTap: scrollUp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: size.width * 0.02),
                        Text(
                          "Home",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).primaryColor),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.red,
                  title: const Text('Connection Lost'),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Oops! It seems you lost your internet connection.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          var connectivityResult = ConnectivityResult.none;
                          if (connectivityResult != ConnectivityResult.none) {
                            _refreshData();
                          } else {
                            errorToast(msg: 'No Internet');
                          }
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
          child: Container(),
        ),
      ),
    );
  }

  buildContainer(context, String name, VoidCallback ontap, String image) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        ontap.call();
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover),
                // color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10)
                // borderRadius: BorderRadius.circular(10000)
                ),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            name,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  categories() {
    return Row(
      children: [
        Expanded(
          child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // childAspectRatio: 0.16 / 0.13,
                mainAxisExtent: 80,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
              ),
              scrollDirection: Axis.vertical,
              itemCount: myServices.length,
              itemBuilder: (context, index) {
                // final product = catController.products[index];
                final service = myServices[index];
                return InkWell(
                  onTap: () {
                    Get.to(() => ServicesScreen(
                          name: service.name,
                          id: service.id.toString(),
                        ));
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(service.imageUrl
                            // fit: BoxFit.cover,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        service.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'hello',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  slider(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 16 / 9,
          viewportFraction: 1.1,
          autoPlayInterval: Duration(seconds: myTime),
          height: size.height * 0.25,
          enableInfiniteScroll: false,
          autoPlay: true),
      items: topImages
          .map((e) => Stack(
                fit: StackFit.expand,
                children: [
                  // Image.asset(
                  //   e,
                  //   fit: BoxFit.cover,
                  // ),
                  Image.network(
                    "$baseUrl/api/allimg/image/$e",
                    headers: {
                      "Authorization": "Bearer $token",
                    },
                  ),
                ],
              ))
          .toList(),
    );
  }

  secondSlider(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CarouselSlider(
      options: CarouselOptions(
          aspectRatio: 1,
          viewportFraction: 1,
          autoPlayInterval: Duration(seconds: myTime),
          height: size.height * 0.2,
          enableInfiniteScroll: false,
          autoPlay: true),
      items: bottomImages
          .map((e) => Stack(
                fit: StackFit.expand,
                children: [
                  // Image.asset(
                  //   e,
                  //   fit: BoxFit.cover,
                  // ),
                  Image.network(
                    "$baseUrl/api/allimg/image/$e",
                    headers: {
                      "Authorization": "Bearer $token",
                    },
                  ),
                ],
              ))
          .toList(),
    );
  }

  final List<int> indexx = [7, 8, 9, 10, 11, 12];
}

class Service {
  final int id;
  final String name;
  final String imageUrl;

  Service(this.id, this.name, this.imageUrl);
}
