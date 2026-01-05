import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/network/services/exraServices/vacancy_controller.dart';
import 'package:smartsewa/utils/debouncer.dart';
import 'package:smartsewa/views/user_screen/main_screen.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/user_vacancy/vacancy_details_body.dart';

import '../../../../core/development/console.dart';
import '../../../../core/enum.dart';
import '../../../serviceProviderScreen/extraServices/upload_vaccancy.dart';
import '../../../widgets/custom_dialogs.dart';
import '../../../widgets/custom_network_image.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/customalert.dart';

class MyVacancyScreen extends StatefulWidget {
  const MyVacancyScreen({Key? key}) : super(key: key);

  @override
  State<MyVacancyScreen> createState() => _VacancyState();
}

class _VacancyState extends State<MyVacancyScreen> {
  final vacancyController = Get.put(VacancyController());
  String? token;

  bool isShowingSearchBar = false;

  @override
  void initState() {
    getToken();
    super.initState();
    isShowingSearchBar = false;
    // controller.getExtraServices();
    // controller.myVacancies;
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    // int? tid = prefs.getInt("id");
    // setState(() {
    token = apptoken;
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    logger(token, loggerType: LoggerType.success);

    return WillPopScope(
      onWillPop: () async {
        vacancyController.fetchVacancy();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: searchBar(context),
          drawerEdgeDragWidth: 150,
          drawer: CustomDrawer(),
          body: Obx(
            () {
              if (vacancyController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (vacancyController.myVacancyResponseModel.isEmpty) {
                return const Center(
                  child: Text(
                    "Vacancy empty",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (vacancyController.myVacancySearchData.isEmpty) {
                return const Center(
                  child: Text(
                    "No search data found",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => vSizedBox1,
                  shrinkWrap: true,
                  itemCount: vacancyController.myVacancySearchData.length,
                  itemBuilder: (context, index) {
                    var vacancyItem =
                        vacancyController.myVacancySearchData[index];
                    return InkWell(
                      onTap: () {
                        Get.to(() => VacancyDetailsBody(
                              title: vacancyItem.title,
                              vacancyId: vacancyItem.vacancyId,
                              token: token,
                            ));
                      },
                      child: Padding(
                        padding: screenLeftRightPadding,
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: appWidth(context) * 0.4,
                                      height: appHeight(context) * 0.2,
                                      child: vacancyItem.picture == null
                                          ? Image.asset(
                                              "assets/vacancy.png",
                                              fit: BoxFit.cover,
                                              width: appWidth(context) * 0.2,
                                            )
                                          : customNetworkImage(
                                              pictureName: vacancyItem.picture,
                                              token: token,
                                            ),
                                    ),
                                    vSizedBox1,
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      width: appWidth(context) * 0.4,
                                      height: 61,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: buildRowContainer(
                                        title: "Title:",
                                        message: vacancyItem.title.toString(),
                                      ),
                                    ),
                                    vSizedBox0,
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 215,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    width: appWidth(context) * 0.4,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          child: Column(
                                            children: [
                                              buildRowContainer(
                                                title: "Position:",
                                                message: vacancyItem.position
                                                    .toString(),
                                              ),
                                              vSizedBox0,
                                              buildRowContainer(
                                                title: "Quantity:",
                                                message: vacancyItem.quantity
                                                    .toString(),
                                              ),
                                              vSizedBox0,
                                              buildRowContainer(
                                                title: "Qualification:",
                                                message: vacancyItem
                                                    .qualification
                                                    .toString(),
                                              ),
                                              vSizedBox0,
                                              buildRowContainer(
                                                title: "Office Name",
                                                message: vacancyItem.officeName
                                                    .toString(),
                                              ),
                                              vSizedBox0,
                                              buildRowContainer(
                                                title: "Address:",
                                                message: vacancyItem.address
                                                    .toString(),
                                              ),
                                              vSizedBox0,
                                              buildRowContainer(
                                                title: "Contact:",
                                                message: vacancyItem.contact
                                                    .toString(),
                                              ),
                                              vSizedBox0,
                                              buildRowContainer(
                                                title: "Cv Email:",
                                                message: vacancyItem
                                                    .applyCvEmail
                                                    .toString(),
                                              ),
                                              vSizedBox0,
                                              buildRowContainer(
                                                title: "Status:",
                                                message: vacancyItem
                                                            .statusAvailable ??
                                                        false
                                                    ? "Available"
                                                    : "Closed",
                                              ),
                                              vSizedBox0,
                                              // buildRowContainer(
                                              //   title: "Expiry:",
                                              //   message: vacancyItem
                                              //       .expirationDate
                                              //       .toString(),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        vSizedBox0,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: SizedBox(
                                                height: 42,
                                                width: 80,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(4),
                                                      ),
                                                      side: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: vacancyItem
                                                              .statusAvailable ==
                                                          false
                                                      ? null
                                                      : () {
                                                          MyDialogs().myAlert(
                                                              context,
                                                              "Edit",
                                                              "Are you sure you want to update the available status?",
                                                              () {
                                                            Get.back();
                                                          }, () {
                                                            Get.back();
                                                            CustomDialogs
                                                                .fullLoadingDialog(
                                                                    context:
                                                                        context,
                                                                    data:
                                                                        "Updating the available status...");
                                                            vacancyController
                                                                .updateAvailableStatusVacancy(
                                                              vacancyId:
                                                                  vacancyItem
                                                                      .vacancyId
                                                                      .toString(),
                                                            );
                                                          });
                                                        },
                                                  child: FittedBox(
                                                    child: CustomText.ourText(
                                                      vacancyItem.statusAvailable ??
                                                              false ||
                                                                  vacancyItem
                                                                          .statusAvailable ==
                                                                      null
                                                          ? "Close Vac"
                                                          : "Closed",
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            vacancyItem.statusAvailable == false
                                                ? Container()
                                                : SizedBox(
                                                    height: 42,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(4),
                                                          ),
                                                          side: BorderSide(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      onPressed: () {
                                                        Get.to(() =>
                                                            UploadVaccancy(
                                                              isFromEdit: true,
                                                              vacancy:
                                                                  vacancyItem,
                                                            ));
                                                      },
                                                      child: CustomText.ourText(
                                                        "Edit",
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            child: SizedBox(
              height: 40,
              child: InkWell(
                onTap: () {
                  Get.offAll(() => const MainScreen());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: appWidth(context) * 0.02),
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
          ),
        ),
      ),
    );
  }

  buildRowContainer({String? title, String? message}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.ourText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        hSizedBox1,
        Expanded(
          child: CustomText.ourText(
            message ?? "",
            fontSize: 15,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  AppBar searchBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xFF86E91A)),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: isShowingSearchBar ? false : true,
      title: isShowingSearchBar
          ? CustomTextFormField(
              filled: true,
              fillColor: Colors.transparent,
              hintText: "Search...",
              textColor: Colors.white,
              controller: vacancyController.vacancySearchController,
              isFromSearch: true,
              textInputAction: TextInputAction.search,
              onChanged: (val) {
                // consolelog(val);
                Debouncer(milliseconds: 100).run(() {
                  if (val.toString().isNotEmpty) {
                    vacancyController.myVacancySearchData.value =
                        vacancyController.myVacancyResponseModel
                            .where((vacancy) {
                      return vacancy.title
                          .toString()
                          .toLowerCase()
                          .contains(val.toString().toLowerCase());
                    }).toList();
                  } else {
                    vacancyController.myVacancySearchData.value =
                        vacancyController.myVacancyResponseModel;
                  }
                  // consolelog(vacancyController.myVacancySearchData);
                });
              },
            )
          : CustomText.ourText(
              "Vacancy",
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isShowingSearchBar = !isShowingSearchBar;
            });
            // Debouncer(milliseconds: 100).run(() {
            //   if (vacancyController.vacancySearchController.text
            //       .toString()
            //       .isNotEmpty) {
            //     vacancyController.myVacancySearchData.value =
            //         vacancyController.myVacancyResponseModel.where((vacancy) {
            //       return vacancy.title.toString().toLowerCase().contains(
            //           vacancyController.vacancySearchController.text
            //               .trim()
            //               .toLowerCase());
            //     }).toList();
            //   } else {
            //     vacancyController.myVacancySearchData.value =
            //         vacancyController.myVacancyResponseModel;
            //   }
            //   // consolelog(vacancyController.myVacancySearchData);
            // });
          },
          icon: const Icon(Icons.search_outlined),
        ),
      ],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  CustomDrawer({
    super.key,
  });

  final vacancyController = Get.put(VacancyController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const UploadVaccancy());
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    "Add new post",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                vacancyController.fetchMyVacancyPost();
                Get.off(() => const MyVacancyScreen());
              },
              child: const Card(
                child: ListTile(
                  title: Text(
                    'Watch your post',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // const Card(
            //   child: ExpansionTile(
            //     title: Text(
            //       'Watch your post',
            //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            //     ),
            //     trailing: Icon(
            //       Icons.arrow_forward_ios_outlined,
            //       color: Colors.black,
            //     ),
            //     children: [
            //       ListTile(
            //         title: Text(
            //           'Edit your post',
            //           style:
            //               TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            //         ),
            //         // trailing: Icon(
            //         //   Icons.arrow_forward_ios_outlined,
            //         //   color: Colors.black,
            //         // ),
            //       ),
            //       ListTile(
            //         title: Text(
            //           'Delete your post',
            //           style:
            //               TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            //         ),
            //         // trailing: Icon(
            //         //   Icons.arrow_forward_ios_outlined,
            //         //   color: Colors.black,
            //         // ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
