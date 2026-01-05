// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

class VacancyTemplate extends StatefulWidget {
  final String? token;
  const VacancyTemplate({
    Key? key,
    this.token,
  }) : super(key: key);

  @override
  State<VacancyTemplate> createState() => _AddNewVacancyState();
}

class _AddNewVacancyState extends State<VacancyTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, true, "Vacancy Template"),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () {
              selectedVacancyTemplate.value =
                  "${BaseClient().baseUrl}/api/allimg/image/1_vacancy_VacancyImg1.png";
              // consolelog(selectedVacancyTemplate.value?.split("/")[6]);
              Get.back();
            },
            child: SizedBox(
              height: 150,
              child: Image.network(
                "${BaseClient().baseUrl}/api/allimg/image/1_vacancy_VacancyImg1.png",
                headers: {
                  'Authorization': "Bearer ${widget.token}",
                },
              ),
            ),
          ),
          SizedBox(
            height: appHeight(context) * 0.03,
          ),
          GestureDetector(
            onTap: () {
              selectedVacancyTemplate.value =
                  "${BaseClient().baseUrl}/api/allimg/image/1_vacancy_VacancyImg2.png";
              Get.back();
            },
            child: SizedBox(
              height: 150,
              child: Image.network(
                "${BaseClient().baseUrl}/api/allimg/image/1_vacancy_VacancyImg2.png",
                headers: {
                  'Authorization': "Bearer ${widget.token}",
                },
              ),
            ),
          ),
          SizedBox(
            height: appHeight(context) * 0.03,
          ),
          GestureDetector(
            onTap: () {
              selectedVacancyTemplate.value =
                  "${BaseClient().baseUrl}/api/allimg/image/1_vacancy_VacancyImg3.png";
              Get.back();
            },
            child: SizedBox(
              height: 150,
              child: Image.network(
                "${BaseClient().baseUrl}/api/allimg/image/1_vacancy_VacancyImg3.png",
                headers: {
                  'Authorization': "Bearer ${widget.token}",
                },
              ),
            ),
          ),
          SizedBox(
            height: appHeight(context) * 0.03,
          ),
          GestureDetector(
            onTap: () {
              selectedVacancyTemplate.value =
                  "${BaseClient().baseUrl}/api/allimg/image/1_vacancy_VacancyImg4.png";
              Get.back();
            },
            child: SizedBox(
              height: 150,
              child: Image.network(
                "${BaseClient().baseUrl}/api/allimg/image/1_vacancy_VacancyImg4.png",
                headers: {
                  'Authorization': "Bearer ${widget.token}",
                },
              ),
            ),
          ),
          SizedBox(
            height: appHeight(context) * 0.03,
          ),
        ],
      ),
    );
  }
}
