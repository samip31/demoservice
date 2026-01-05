import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/my_appbar.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({Key? key}) : super(key: key);

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool switchValue1 = true;
  bool switchValue2 = true;
  bool switchValue3 = true;
  bool switchValue4 = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppbar(context, true, ""),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.05),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(size.aspectRatio * 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notification Settings',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Card(
                      child: ListTile(
                        leading: const Text(
                          'Random List',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        trailing: Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            activeColor: Colors.red,
                            value: switchValue1,
                            onChanged: (value) {
                              setState(() {
                                switchValue1 = !switchValue1;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Text(
                          'Random List',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        trailing: Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            activeColor: Colors.red,
                            value: switchValue2,
                            onChanged: (value) {
                              setState(() {
                                switchValue2 = !switchValue2;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Text(
                          'Random List',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        trailing: Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            activeColor: Colors.red,
                            value: switchValue3,
                            onChanged: (value) {
                              setState(() {
                                switchValue3 = !switchValue3;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: const Text(
                          'Random List',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        trailing: Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            activeColor: Colors.red,
                            value: switchValue4,
                            onChanged: (value) {
                              setState(() {
                                switchValue4 = !switchValue4;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
