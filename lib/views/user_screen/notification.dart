// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/models/notification_model/user_model.dart';
import 'package:smartsewa/network/services/notification_services/notification_controller.dart';
import 'package:smartsewa/views/widgets/custom_text.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

class NotificationScreen extends StatefulWidget {
  List<UserNotificationModel> notifications;
  final bool? isFromServiceScreen;
  NotificationScreen({
    Key? key,
    required this.notifications,
    this.isFromServiceScreen,
  }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final notificationsController = Get.put(NotificationController());
  @override
  void initState() {
    super.initState();
    d();

    // notificationsController.fetchUserNotifications().then((data) {
    //   setState(() {
    //     widget.notifications = [];
    //   });
    // }).catchError((error) {
    //   print('Failed to fetch notifications: $error');
    // });
  }

  d() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? tid = prefs.getInt("id");
    print(tid);
    print(apptoken);
  }

  void markNotificationAsSeen(int notificationId) {
    notificationsController
        .updateNotificationSeenStatus(notificationId)
        .then((_) {
      setState(() {
        // Find the index of the updated notification
        final index = notificationsController.userNotifications.indexWhere(
            (notification) => notification['notificationId'] == notificationId);
        if (index != -1) {
          // Update the "seen" status of the notification in the list
          notificationsController.userNotifications[index].seen = true;
        }
      });
    }).catchError((error) {
      print('Failed to update notification seen status: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.isFromServiceScreen ?? false
            ? null
            : myAppbar(context, true, "Notification"),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                onTap: (index) {
                  index == 1
                      ? notificationsController
                          .fetchUserNotifications()
                          .then((data) {
                          notificationsController
                              .updateUserNotificationsSeenStatus();
                        }).catchError((error) {
                          consolelog('Failed to fetch notifications: $error');
                        })
                      : null;
                },
                tabs: [
                  Tab(
                    // text: 'Admin',
                    child: Text(
                      'Admin',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'User',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.white),
                    ),
                  )
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  _buildAdminNotifications(),
                  _buildUserNotifications(),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminNotifications() {
    return Obx(
      () => notificationsController.adminNotifications.isEmpty
          ? Center(
              child: CustomText.ourText("Empty"),
            )
          : ListView.builder(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: notificationsController.adminNotifications.length,
              itemBuilder: (context, index) {
                final notification =
                    notificationsController.adminNotifications[index];
                final date = notification.dateAndTime?.split('T')[0];

                return Card(
                  elevation: 3,
                  child: ListTile(
                    title: Text(notification.title),
                    subtitle: Text(notification.information),
                    trailing: Text(date.toString()),
                    onTap: () {},
                  ),
                );
              },
            ),
    );
  }

  Widget _buildUserNotifications() {
    return Obx(
      () => notificationsController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : notificationsController.userNotifications.isEmpty
              ? Center(
                  child: CustomText.ourText("Empty"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: notificationsController.userNotifications.length,
                  itemBuilder: (context, index) {
                    final notification =
                        notificationsController.userNotifications[index];
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text(notification.notificationType),
                        subtitle: Text(notification.information),
                        trailing: Text(notification.dateAndTime),
                        onTap: () {
                          // markNotificationAsSeen(notification.notificationId);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
