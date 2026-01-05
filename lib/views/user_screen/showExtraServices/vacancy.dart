import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/dimension.dart';
import 'package:smartsewa/network/services/exraServices/vacancy_controller.dart';
import 'package:smartsewa/utils/debouncer.dart';
import 'package:smartsewa/views/serviceProviderScreen/service_main_screen.dart';
import 'package:smartsewa/views/user_screen/main_screen.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/user_vacancy/my_vacancy_screen.dart';
import 'package:smartsewa/views/user_screen/showExtraServices/user_vacancy/vacancy_details_body.dart';

import '../../../core/development/console.dart';
import '../../../core/enum.dart';
import '../../serviceProviderScreen/extraServices/upload_vaccancy.dart';
import '../../widgets/custom_network_image.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_text_form_field.dart';

class Vacancy extends StatefulWidget {
  final bool? isFromServiceScreen;
  const Vacancy({Key? key, this.isFromServiceScreen = false}) : super(key: key);

  @override
  State<Vacancy> createState() => _VacancyState();
}

class _VacancyState extends State<Vacancy> {
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

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          widget.isFromServiceScreen ?? false
              ? Get.offAll(() => const ServiceMainScreen())
              : Get.offAll(() => const MainScreen());
          return true;
        },
        child: Scaffold(
          appBar: searchBar(context),
          drawerEdgeDragWidth: 150,
          drawer: CustomDrawer(isFromServiceScreen: widget.isFromServiceScreen),
          body: Obx(
            () {
              if (vacancyController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (vacancyController.vacancyResponseModel.isEmpty) {
                return const Center(
                  child: Text(
                    "Vacancy empty",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              } else if (vacancyController.vacancySearchData.isEmpty) {
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
                  key: const PageStorageKey<String>("vacancy_screen"),
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => vSizedBox1,
                  shrinkWrap: true,
                  itemCount: vacancyController.vacancySearchData.length,
                  itemBuilder: (context, index) {
                    var vacancyItem =
                        vacancyController.vacancySearchData[index];
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
                                    padding: const EdgeInsets.all(4),
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
                                        buildRowContainer(
                                          title: "Position:",
                                          message:
                                              vacancyItem.position.toString(),
                                        ),
                                        vSizedBox0,
                                        buildRowContainer(
                                          title: "Quantity:",
                                          message:
                                              vacancyItem.quantity.toString(),
                                        ),
                                        vSizedBox0,
                                        buildRowContainer(
                                          title: "Qualification:",
                                          message: vacancyItem.qualification
                                              .toString(),
                                        ),
                                        vSizedBox0,
                                        buildRowContainer(
                                          title: "Office Name",
                                          message:
                                              vacancyItem.officeName.toString(),
                                        ),
                                        vSizedBox0,
                                        buildRowContainer(
                                          title: "Address:",
                                          message:
                                              vacancyItem.address.toString(),
                                        ),
                                        vSizedBox0,
                                        buildRowContainer(
                                          title: "Contact:",
                                          message:
                                              vacancyItem.contact.toString(),
                                        ),
                                        vSizedBox0,
                                        buildRowContainer(
                                          title: "Cv Email:",
                                          message: vacancyItem.applyCvEmail
                                              .toString(),
                                        ),
                                        vSizedBox0,
                                        buildRowContainer(
                                          title: "Status:",
                                          message:
                                              vacancyItem.statusAvailable ??
                                                      false
                                                  ? "Available"
                                                  : "Closed",
                                        ),
                                        vSizedBox0,
                                        // buildRowContainer(
                                        //   title: "Expiry:",
                                        //   message: vacancyItem.expirationDate
                                        //       .toString(),
                                        // ),
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
          // bottomNavigationBar: BottomAppBar(
          //   color: Colors.black,
          //   child: SizedBox(
          //     height: 40,
          //     child: InkWell(
          //       onTap: () {
          //         widget.isFromServiceScreen ?? false
          //             ? Get.offAll(() => const ServiceMainScreen())
          //             : Get.offAll(() => const MainScreen());
          //       },
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Icon(
          //             Icons.home,
          //             size: 30,
          //             color: Theme.of(context).primaryColor,
          //           ),
          //           SizedBox(width: appWidth(context) * 0.02),
          //           Text(
          //             "Home",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 18,
          //                 color: Theme.of(context).primaryColor),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
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
                    vacancyController.vacancySearchData.value =
                        vacancyController.vacancyResponseModel.where((vacancy) {
                      return vacancy.title
                          .toString()
                          .toLowerCase()
                          .contains(val.toString().toLowerCase());
                    }).toList();
                  } else {
                    vacancyController.vacancySearchData.value =
                        vacancyController.vacancyResponseModel;
                  }
                  // consolelog(vacancyController.vacancySearchData);
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
            //     vacancyController.vacancySearchData.value =
            //         vacancyController.vacancyResponseModel.where((vacancy) {
            //       return vacancy.title.toString().toLowerCase().contains(
            //           vacancyController.vacancySearchController.text
            //               .trim()
            //               .toLowerCase());
            //     }).toList();
            //   } else {
            //     vacancyController.vacancySearchData.value =
            //         vacancyController.vacancyResponseModel;
            //   }
            //   // consolelog(vacancyController.vacancySearchData);
            // });
          },
          icon: const Icon(Icons.search_outlined),
        ),
      ],
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final bool? isFromServiceScreen;
  CustomDrawer({
    super.key,
    this.isFromServiceScreen,
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
                  // Get.to(() => const Payment(
                  //       serviceType: "vacancy",
                  //     ));
                  Get.to(() => UploadVaccancy(
                        isFromServiceScreen: isFromServiceScreen,
                      ));
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
                Get.to(() => const MyVacancyScreen());
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
            InkWell(
              onTap: () {
                isFromServiceScreen ?? false
                    ? Get.offAll(() => const ServiceMainScreen())
                    : Get.offAll(() => const MainScreen());
              },
              child: const Card(
                child: ListTile(
                  title: Text(
                    'Home',
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
