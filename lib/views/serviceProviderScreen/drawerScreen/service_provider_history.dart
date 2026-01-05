import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/my_appbar.dart';

class ServiceProviderHistory extends StatelessWidget {
  const ServiceProviderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, ""),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.01),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                child: Column(
                  children: [
                    Text(
                      'History',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: 18,
                        itemBuilder: (context, index) {
                          return Card(
                              shape: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: const Icon(
                                    CupertinoIcons.home,
                                    color: Colors.black,
                                  ),
                                  trailing: const Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        'Ram Thapa',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '2022-02-03',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  title: Column(
                                    children: [
                                      const Text('Plumbing'),
                                      Container(
                                        height: 10,
                                        width: 80,
                                        color: Colors.red,
                                      )
                                    ],
                                  ),
                                ),
                              ));
                        },
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
