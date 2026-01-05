import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartsewa/views/user_screen/order_status/history.dart';
import 'package:smartsewa/views/user_screen/order_status/sent_request.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

import 'ongoing_service_user.dart';

class OrderStatus extends StatelessWidget {
  OrderStatus({Key? key}) : super(key: key);

  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, "Service Status"),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                onTap: (value) => selectedIndex.value = value,
                labelColor: Colors.white,
                labelStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                indicatorColor: Colors.greenAccent,
                tabs: const [
                  Tab(text: "Request"),
                  Tab(text: "Ongoing"),
                  Tab(text: "History"),
                ],
              ),
              Expanded(child: Obx(() {
                switch (selectedIndex.value) {
                  case 0:
                    return const SentRequest();
                  case 1:
                    return const OngoingServiceUser();
                  case 2:
                    return HistoryScreen();
                  default:
                    return Container();
                }
              }))
            ],
          ),
        ),
      ),
    );
  }

  tabName(String name) {
    return Text(
      name,
      style: const TextStyle(
          fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
    );
  }
}
