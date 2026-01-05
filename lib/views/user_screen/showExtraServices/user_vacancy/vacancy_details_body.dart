import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/views/widgets/custom_text.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

import '../../../../network/services/exraServices/vacancy_controller.dart';
import '../../../widgets/custom_network_image.dart';
import '../image_details_extraservice.dart';

class VacancyDetailsBody extends StatefulWidget {
  final String? title;
  final int? vacancyId;
  final String? token;
  const VacancyDetailsBody({
    Key? key,
    this.title,
    this.vacancyId,
    this.token,
  }) : super(key: key);

  @override
  State<VacancyDetailsBody> createState() => _VacancyDetailsBodyState();
}

class _VacancyDetailsBodyState extends State<VacancyDetailsBody> {
  final vacancyController = Get.put(VacancyController());

  @override
  void initState() {
    super.initState();

    vacancyController.fetchInidividualVacancy(vacancyId: widget.vacancyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar(
        context,
        true,
        "Vacancy",
      ),
      body: Padding(
        padding: screenLeftRightPadding,
        child: Obx(
          () {
            return vacancyController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : vacancyController
                            .individualVacancyResponseModel.value.vacancyId ==
                        null
                    ? const Center(
                        child: Text(
                          "Error fetching details",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          vSizedBox0,
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ImageDetailsExtraService(
                                    image: vacancyController
                                        .individualVacancyResponseModel
                                        .value
                                        .picture,
                                    token: widget.token,
                                    title: "Vacancy",
                                  ));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 250,
                                    maxHeight: 250,
                                  ),
                                  child: vacancyController
                                              .individualVacancyResponseModel
                                              .value
                                              .picture ==
                                          null
                                      ? Image.asset(
                                          "assets/vacancy.png",
                                          fit: BoxFit.cover,
                                        )
                                      : customNetworkImage(
                                          pictureName: vacancyController
                                              .individualVacancyResponseModel
                                              .value
                                              .picture,
                                          token: widget.token,
                                        ),
                                ),
                              ],
                            ),
                          ),
                          vSizedBox3,
                          buildVacancyRowInformation(
                            title: "Title:",
                            value: vacancyController
                                .individualVacancyResponseModel.value.title,
                          ),
                          vSizedBox2,
                          buildVacancyRowInformation(
                            title: "Position:",
                            value: vacancyController
                                .individualVacancyResponseModel.value.position,
                          ),
                          vSizedBox2,
                          buildVacancyRowInformation(
                            title: "Quantity:",
                            value: vacancyController
                                .individualVacancyResponseModel.value.quantity,
                          ),
                          vSizedBox2,
                          buildVacancyRowInformation(
                            title: "Qualification:",
                            value: vacancyController
                                .individualVacancyResponseModel
                                .value
                                .qualification,
                          ),
                          vSizedBox2,
                          buildVacancyRowInformation(
                            title: "Office Name:",
                            value: vacancyController
                                .individualVacancyResponseModel
                                .value
                                .officeName,
                          ),
                          vSizedBox2,
                          buildVacancyRowInformation(
                            title: "Address:",
                            value: vacancyController
                                .individualVacancyResponseModel.value.address,
                          ),
                          vSizedBox2,
                          buildVacancyRowInformation(
                            title: "Posted By:",
                            value: vacancyController
                                .individualVacancyResponseModel
                                .value
                                .contactPerson,
                          ),
                          vSizedBox2,
                          buildVacancyRowInformation(
                            title: "Contact Number:",
                            value: vacancyController
                                .individualVacancyResponseModel.value.contact,
                          ),
                          vSizedBox2,
                          buildVacancyRowInformation(
                            title: "Apply Cv Email:",
                            value: vacancyController
                                .individualVacancyResponseModel
                                .value
                                .applyCvEmail,
                          ),
                          vSizedBox2,
                          buildVacancyRowInformation(
                            title: "Expiry Date:",
                            value: DateFormat().format(
                              vacancyController.individualVacancyResponseModel
                                      .value.expirationDate ??
                                  DateTime.now(),
                            ),
                          ),
                        ],
                      );
          },
        ),
      ),
    );
  }
}

Widget buildVacancyRowInformation({String? title, String? value}) {
  return Row(
    children: [
      CustomText.ourText(
        title,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      hSizedBox1,
      Expanded(
        child: CustomText.ourText(
          value ?? "",
          fontSize: 16,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
          isMaxLine: false,
        ),
      ),
    ],
  );
}
