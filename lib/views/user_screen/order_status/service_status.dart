import 'package:flutter/material.dart';
import 'package:smartsewa/views/user_screen/order_status/sent_request.dart';

import 'history.dart';
import 'ongoing_service_user.dart';

class ServiceStatus extends StatelessWidget {
  const ServiceStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            'Service Status',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
          bottom: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              tabs: const [
                Tab(
                  child: Text('Requested'),
                ),
                Tab(
                  child: Text('Ongoing'),
                ),
                Tab(
                  child: Text('History'),
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            const SentRequest(),
            const OngoingServiceUser(),
            HistoryScreen()
          ],
        ),
      ),
    );
  }
}
