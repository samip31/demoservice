import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/network/base_client.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/views/user_screen/drawer%20screen/map_Screen.dart';
import '../../../network/models/servicemodel.dart';
import '../../widgets/my_appbar.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key, required this.id, required this.name})
      : super(key: key);
  final String id;
  final String name;

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final controller = Get.put(AuthController());
  var controllerImage;

  checkImage() {
    if (widget.name == "Electrical") {
      controllerImage = "assets/category_image/Electician.jpg";
    } else if (widget.name == "Plumbing") {
      controllerImage = "assets/category_image/Plumber.jpg";
    } else if (widget.name == "Masonry Works") {
      controllerImage = "assets/category_image/Masonry.jpg";
    } else if (widget.name == "Metal Works") {
      controllerImage = "assets/category_image/metal_works.jpg";
    } else if (widget.name == "Cleaning") {
      controllerImage = "assets/category_image/Cleaning.jpg";
    } else if (widget.name == "Carpentry") {
      controllerImage = "assets/category_image/Carpenture_1.jpg";
    } else if (widget.name == "Tuition and Languages") {
      controllerImage = "assets/category_image/Tuition _ Language classes.jpg";
    } else if (widget.name == "Music and Dance") {
      controllerImage = "assets/category_image/Music and Dance classes.jpg";
    } else if (widget.name == "Paint and Painting") {
      controllerImage = "assets/category_image/Paint _ Painting.jpg";
    } else if (widget.name == "Gardener and Agriculture Works") {
      controllerImage = "assets/category_image/Gardener.jpg";
    } else if (widget.name == "Healthcare and Medicine") {
      controllerImage = "assets/category_image/Health medicine _ Pathology.jpg";
    } else if (widget.name == "Veterinary and Pet Care") {
      controllerImage = "assets/category_image/Veterinary.jpg";
    } else if (widget.name == "Fitness and Yoga") {
      controllerImage = "assets/category_image/Fitness, yoga, med.jpg";
    } else if (widget.name == "Cook and Waiter") {
      controllerImage =
          "assets/category_image/Cook, Waiter, Kitchen helper.jpg";
    } else if (widget.name == "Home Care Staff") {
      controllerImage = "assets/category_image/Home care staff.jpg";
    } else if (widget.name == "Books and Stationery") {
      controllerImage = "assets/category_image/Books _ Stationery.jpg";
    } else if (widget.name == "Printing and Press") {
      controllerImage = "assets/category_image/Printing _ Press.jpg";
    } else if (widget.name == "Waste Management") {
      controllerImage = "assets/category_image/waste management.jpg";
    } else if (widget.name == "Catering and Rent") {
      controllerImage = "assets/category_image/Catering _ Rent.jpg";
    } else if (widget.name == "Furniture and Home Decor") {
      controllerImage =
          "assets/category_image/Furniture, Home decor _ Wallpaper.jpg";
    } else if (widget.name == "Vehicle (Yatayat)") {
      controllerImage =
          "assets/category_image/Transportation _ vehicle Rent.jpg";
    } else if (widget.name == "Travel and Tours") {
      controllerImage = "assets/category_image/Travel _ Tour.jpg";
    } else if (widget.name == "Training and Skill Program") {
      controllerImage = "assets/category_image/Training _ skill program.jpg";
    } else if (widget.name == "Event and Party") {
      controllerImage = "assets/category_image/Event _ Party Planner.jpg";
    } else if (widget.name == "Engineering") {
      controllerImage = "assets/category_image/Engineering.jpg";
    } else if (widget.name == "Office Staff") {
      controllerImage = "assets/category_image/Office Staff.jpg";
    } else if (widget.name == "Advertisement and Promotion") {
      controllerImage = "assets/category_image/Advertisement _ Promotion_3.jpg";
    } else if (widget.name == "Dharmik Karyakram") {
      controllerImage = "assets/category_image/dharmik.jpg";
    } else if (widget.name == "Many More") {
      controllerImage = "assets/category_image/Others.jpg";
    }
  }

  @override
  void initState() {
    checkImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, widget.name),
      body: Container(
        // margin: const EdgeInsets.only(top: 18),
        width: double.infinity,
        decoration: const BoxDecoration(
            // borderRadius: BorderRadius.only(
            //   topRight: Radius.circular(30),
            //   topLeft: Radius.circular(30),
            // ),
            color: Colors.white),
        child: Column(
          children: [
            controllerImage == null
                ? Image.asset('assets/Logo.png')
                : Image.asset(controllerImage),
            // const Divider(
            //   color: Colors.black,
            //   thickness: 0.6,
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FutureBuilder(
                    future: fetchServices(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                controller.pickedJobFieldName.value =
                                    snapshot.data![index].name ?? "";
                                Get.to(() => MapScreen(
                                      work: snapshot.data![index].category
                                              ?.categoryTitle ??
                                          "",
                                      name: snapshot.data?[index].name ?? "",
                                    ));

                                // MapScreen(jobName:
                                //       work: snapshot
                                //           .data![index].category.categoryTitle,
                                //     ));
                              },
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  child: Text(
                                    snapshot.data?[index].name ?? "",
                                    style: const TextStyle(
                                      letterSpacing: 0.51,
                                      fontFamily: 'hello',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  String baseUrl = BaseClient().baseUrl;

  Future<List<ServicesList>> fetchServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    log(id.toString());
    log('Get services init $apptoken');
    // log('get service ${controller.token}');

    final res = await http.get(
      Uri.parse('$baseUrl/api/category/${widget.id}/services'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': "Bearer $apptoken"
      },
    );
    consolelog(res.body);
    List myList = jsonDecode(res.body);
    return myList.map((e) => ServicesList.fromJson(e)).toList();
  }
}
