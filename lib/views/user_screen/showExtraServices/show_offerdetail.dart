import 'package:flutter/material.dart';
import '../../widgets/my_appbar.dart';

class WorkDetailScreen extends StatelessWidget {
  final String title;
  final String appTitle;
  final String contactPerson;
  final String contactNo;
  final String address;
  final String price;
  final String negotiable;
  final String expireDate;
  final String brand;
  final String condition;
  final String delivery;
  final String warranty;
  final String deliveryCharge;
  final String period;

  final String desc;
  final String image;

  const WorkDetailScreen(
      {super.key,
      required this.image,
      required this.appTitle,
      required this.title,
      required this.contactPerson,
      required this.contactNo,
      required this.address,
      required this.price,
      required this.negotiable,
      required this.expireDate,
      required this.desc,
      required this.brand,
      required this.condition,
      required this.delivery,
      required this.deliveryCharge,
      required this.warranty,
      required this.period});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: myAppbar(context, true, appTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.black,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                      'http://13.232.92.169:9000/api/allimg/image/$image',
                      width: size.width * 0.4,
                      fit: BoxFit.fill,
                      height: size.height * 0.2),
                  SizedBox(width: size.width * 0.05),
                  Expanded(
                      child: Column(
                    children: [
                      Text(
                        contactPerson,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        contactNo,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        address,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        price,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        negotiable,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        expireDate,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: size.height * 0.02),
                    ],
                  ))
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  brand,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: size.height * 0.01),
                Text(desc,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
                SizedBox(height: size.height * 0.01),
                Text(condition,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(delivery,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        )),
                    Text(deliveryCharge,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        )),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(warranty,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        )),
                    Text(period,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
