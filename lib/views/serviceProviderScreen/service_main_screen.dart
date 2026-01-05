import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/services/notification_services/notification_controller.dart';
import 'package:smartsewa/network/services/userdetails/current_user_controller.dart';
import 'package:smartsewa/views/serviceProviderScreen/bottomNavigation/payment_screen_service.dart';
import 'package:smartsewa/views/serviceProviderScreen/serviceProfile/service_provider_profile.dart';
import 'package:smartsewa/views/serviceProviderScreen/service_home_screen.dart';
import 'package:smartsewa/views/user_screen/main_screen.dart';
import 'package:smartsewa/views/user_screen/notification.dart';
import '../auth/login/login_screen.dart';
import '../user_screen/drawer screen/privacypolicyscreen.dart';
import '../user_screen/drawer screen/about_us.dart';
import '../user_screen/drawer screen/contact_screen.dart';
import '../user_screen/setting/setting.dart';
import '../widgets/customalert.dart';
import 'extraServices/upload_extra_services.dart';

class ServiceMainScreen extends StatefulWidget {
  const ServiceMainScreen({super.key});

  @override
  State<ServiceMainScreen> createState() => _ServiceMainScreenState();
}

class _ServiceMainScreenState extends State<ServiceMainScreen> {
  int _currentIndex = 0;
  final notificationsController = Get.put(NotificationController());
  final currentUserController = Get.put(CurrentUserController());
  List<dynamic> notifications = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      currentUserController.getCurrentUser();
    });
    notificationsController.fetchUserNotifications().then((data) {
      // setState(() {
      //   notifications = data!;
      // });
    }).catchError((error) {
      print("service notification: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    //  bool hasUnseenNotifications =
    //     notifications.any((notification) => !notification['seen']);
    Size size = MediaQuery.of(context).size;
    final screens = [
      const ServiceHomeScreen(),
      const UploadServiceScreen(),
      NotificationScreen(
        notifications: const [],
        isFromServiceScreen: true,
      ),
      const ServiceProfile(),
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
        backgroundColor: Colors.black,
      ),
      // body: ValueListenableBuilder(
      //   valueListenable: serviceMainCurrentIndex,
      //   builder: (context, value, child) => screens[value],
      // ),
      body: screens[_currentIndex],
      drawerEdgeDragWidth: 150,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.05),
              // buildItem('Chat', Icons.chat, () {}),
              // buildItem('Offer', Icons.card_giftcard, () {
              //   Get.to(() => const OfferSubscription(
              //         extraService: null,
              //       ));
              // }),
              buildItem('Payment', Icons.card_giftcard, () {
                // Get.to(() => const PaymentScreenService());
                // const PaymentScreenKhalti(
                //       serviceType: '',
                //     ));
              }),
              buildItem('Setting', Icons.settings_outlined, () {
                // Get.to(() => const ServiceProviderSettingPage());
                Get.to(() => const SettingPage());
              }),
              buildItem('Terms & Conditions', Icons.book_outlined, () {
                Get.to(() => const PrivacypolicyScreen());
              }),
              buildItem('About Us', CupertinoIcons.question_circle, () {
                Get.to(const AboutUS());
              }),
              buildItem('Contact', Icons.phone_outlined, () {
                Get.to(const ContactScreen());
              }),
              const Spacer(),
              buildItem('User', Icons.person_outline, () {
                Get.back();
                Get.back();
              }),
              Card(
                child: ListTile(
                  onTap: () {
                    MyDialogs().myAlert(
                      context,
                      'Logout!!',
                      'Are you sure, you want to logout?',
                      () {
                        Get.back();
                      },
                      () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        await preferences.remove('token');
                        await preferences.remove('id');
                        await preferences.remove('workStatus');
                        await preferences.setBool('rememberMe', false);
                        Get.offAll(const LoginScreen());
                      },
                    );
                  },
                  title: const Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  leading: Icon(
                    Icons.logout_outlined,
                    size: 25,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedItemColor: Colors.white30,
        selectedIconTheme: const IconThemeData(size: 25),
        selectedItemColor: Theme.of(context).primaryColor,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // serviceMainCurrentIndex.value = index;
        },
        items: const [
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.home),
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.cloud_upload),
            icon: Icon(CupertinoIcons.cloud_upload),
            label: 'Offer',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_none),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  buildItem(String name, icon, onTap) {
    return Card(
      child: ListTile(
        onTap: () {
          onTap.call();
        },
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        leading: Icon(
          icon,
          size: 25,
          color: Theme.of(context).primaryColor,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_outlined,
          color: Colors.black,
        ),
      ),
    );
  }
}
