import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/models/categories/service_model.dart';
import 'package:smartsewa/network/services/authServices/register_service.dart';
import 'package:smartsewa/network/services/categories&services/service_controller.dart';
import 'package:smartsewa/views/user_screen/main_screen.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import '../../../core/route_navigation.dart';
import '../../../core/states.dart';
import '../../../network/base_client.dart';
import '../../../network/models/categories/category_model.dart';
import '../../../network/services/categories&services/categories_controller.dart';
import '../../../network/services/exraServices/payment_controller.dart';
import '../../widgets/custom_dialogs.dart';
import '../../widgets/custom_search_dropdown.dart';
import '../../widgets/my_appbar.dart';
import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/ovelayed_loading_screen.dart';
import 'citizenshipimagebox.dart';
import 'imagesdecor.dart';
import 'map_controller.dart';
import 'open_map_screen.dart';

class ApprovalScreen extends StatefulWidget {
  final mapController = Get.put(MapController());
  final String email;
  final String password;
  final String mobileNumber;

  ApprovalScreen(
      {Key? key,
      required this.email,
      required this.password,
      required this.mobileNumber})
      : super(key: key);

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final _formkey = GlobalKey<FormState>();
  final getController = Get.put(RegisterServiceController());
  final catController = Get.put(CatController());
  final serviceController = Get.put(ServicesController());
  final companyName = TextEditingController();
  // final categoryController = Get.put(CategoryController());
  final paymentController = Get.put(PaymentController());
  int? selectedCategoryId;
  String baseUrl = BaseClient().baseUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(context, true, ""),
      body: Stack(
        children: [
          Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // SizedBox(height: size.height * 0.01),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.only(
                        //     topRight: Radius.circular(30),
                        //     topLeft: Radius.circular(30)),
                        color: Colors.white),
                    child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.all(size.aspectRatio * 55),
                          child: Column(
                            children: [
                              Text(
                                'Approval Form',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              SizedBox(height: size.height * 0.02),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.category_outlined,
                                    size: 30,
                                    color: Color(0xFF889AAD),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Job Title',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              CustomSearchDropDown<Category>(
                                hintText: 'Job Title',
                                asyncItems: (String? filter) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? apptoken = prefs.getString("token");
                                  var response = await Dio()
                                      .get('$baseUrl/api/categories/',
                                          options: Options(headers: {
                                            HttpHeaders.authorizationHeader:
                                                'Bearer $apptoken',
                                          }));
                                  var models = (response.data as List)
                                      .map((e) => Category.fromJson(e))
                                      .toList();
                                  return models;
                                },
                                itemAsString: (Category? category) =>
                                    category?.categoryTitle ?? "",
                                validator: (Category? item) {
                                  if (item == null) {
                                    return "This field is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (Category? category) {
                                  setState(() {
                                    selectedCategories =
                                        category!.categoryTitle;
                                    selectedCategoryId = category.categoryId;
                                    print(
                                        '$selectedCategories$selectedCategoryId');
                                  });
                                },
                                items: const [],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.construction_outlined,
                                    size: 30,
                                    color: Color(0xFF889AAD),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Job Field',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              CustomSearchDropDown<Serviced>(
                                enabled:
                                    selectedCategoryId == null ? false : true,
                                hintText: 'Job Field',
                                asyncItems: (String? filter) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String? apptoken = prefs.getString("token");
                                  var response = await Dio().get(
                                      '$baseUrl/api/category/$selectedCategoryId/services',
                                      options: Options(headers: {
                                        HttpHeaders.authorizationHeader:
                                            'Bearer $apptoken',
                                      }));
                                  var models = (response.data as List)
                                      .map((e) => Serviced.fromJson(e))
                                      .toList();
                                  return models;
                                },
                                itemAsString: (Serviced? service) =>
                                    service?.name ?? "",
                                validator: (Serviced? item) {
                                  if (item == null) {
                                    return "This field is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (Serviced? serviced) {
                                  setState(() {
                                    selectedService = serviced!.name;
                                    print('$selectedService');
                                  });
                                },
                                items: const [],
                              ),

                              // categoriesField(),

                              //  SizedBox(height: size.height * 0.02),
                              // EmailTextField(
                              //     controller: TextEditingController()),
                              // SizedBox(height: size.height * 0.02),
                              // categoriesJobField(),

                              // Obx(
                              //   () => Container(
                              //     width: double.infinity,
                              //     height: 60,
                              //     padding: const EdgeInsets.symmetric(
                              //       horizontal: 12,
                              //       vertical: 4,
                              //     ),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(18),
                              //       border: Border.all(
                              //         color: const Color(0xFF889AAD),
                              //       ),
                              //     ),
                              //     child: DropdownButtonHideUnderline(
                              //       child: DropdownButton<String>(
                              //         isExpanded: true,
                              //         value: categoryController
                              //             .selectedCategory.value,
                              //         items: categoryController.categoryList
                              //             .map((category) {
                              //           return DropdownMenuItem<String>(
                              //             value: category.categoryId
                              //                 .toString(),
                              //             child:
                              //                 Text(category.categoryTitle),
                              //           );
                              //         }).toList(),
                              //         onChanged: (value) {
                              //           categoryController.selectedCategory
                              //               .value = value!;
                              //           int categoryId = int.parse(value);
                              //           categoryController
                              //               .fetchServices(categoryId);
                              //         },
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(height: size.height * 0.02),
                              // Obx(
                              //   () => Container(
                              //     width: double.infinity,
                              //     height: 60,
                              //     padding: const EdgeInsets.symmetric(
                              //       horizontal: 12,
                              //       vertical: 4,
                              //     ),
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(18),
                              //       border: Border.all(
                              //         color: const Color(0xFF889AAD),
                              //       ),
                              //     ),
                              //     child: DropdownButtonHideUnderline(
                              //       child: DropdownButton<String>(
                              //         isExpanded: true,
                              //         value: categoryController
                              //             .selectedService.value,
                              //         items: categoryController.serviceList
                              //             .map((service) {
                              //           return DropdownMenuItem<String>(
                              //             value: service.id.toString(),
                              //             child: Text(service.name),
                              //           );
                              //         }).toList(),
                              //         onChanged: (value) {
                              //           categoryController
                              //               .selectedService.value = value!;
                              //         },
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              // StringTextField(
                              //     fill: false,
                              //     name: "Job Field",
                              //     controller: companyName,
                              //     boxIcon: Icons.construction_outlined,
                              //     hintText: "Chimney"),

                              // SizedBox(height: size.height * 0.02),
                              citizenshipnumber(),
                              SizedBox(height: size.height * 0.02),
                              locationButton(),
                              SizedBox(height: size.height * 0.02),

                              citizenshipfield(),
                              SizedBox(height: size.height * 0.02),

                              CitizenshipImageBox(
                                  image: _citizenshipfront,
                                  onTap: () {
                                    selectSource(statusOfImage: 1);
                                  },
                                  hinttext: ''
                                      'National ID Front'),
                              SizedBox(height: size.height * 0.02),
                              CitizenshipImageBox(
                                  image: _citizenshipback,
                                  onTap: () {
                                    selectSource(statusOfImage: 2);
                                  },
                                  hinttext: 'National ID Back'),
                              SizedBox(height: size.height * 0.02),
                              ImageBox(
                                  image: _academicimage,
                                  onTap: () {
                                    selectSource(statusOfImage: 3);
                                  },
                                  name: 'Academic Image'),

                              SizedBox(height: size.height * 0.02),
                              ImageBox(
                                  image: _associationimage,
                                  onTap: () {
                                    selectSource(statusOfImage: 4);
                                  },
                                  name: 'Association Image'),

                              SizedBox(height: size.height * 0.02),

                              // ImageBox(
                              //     image: _cvimage,
                              //     onTap: () {
                              //       pickcv();
                              //     },
                              //     name: 'Curriculum vitae (CV)'),
                              SizedBox(height: size.height * 0.03),
                              loginfiled(),
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
          Obx(
            () => widget.mapController.isMapLoading.value
                ? const OverlayedLoadingScreen()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Future pickImageData({ImageSource? imageSource, int? statusOfImage}) async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: imageSource ?? ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        statusOfImage == 1
            ? _citizenshipfront = File(pickedImage.path)
            : statusOfImage == 2
                ? _citizenshipback = File(pickedImage.path)
                : statusOfImage == 3
                    ? _academicimage = File(pickedImage.path)
                    : _associationimage = File(pickedImage.path);
      });
    } else {
      errorToast(msg: "No image picked");
    }
  }

  void selectSource({int? statusOfImage}) {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          child: AlertDialog(
            title: const Center(
                child: Text(
              "Select",
              style: TextStyle(fontSize: 21, color: Colors.black),
            )),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed: () {
                        pickImageData(
                            imageSource: ImageSource.gallery,
                            statusOfImage: statusOfImage);
                        back(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined),
                          SizedBox(
                            width: 1,
                          ),
                          Text("Gallery"),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      pickImageData(
                          imageSource: ImageSource.camera,
                          statusOfImage: statusOfImage);
                      back(context);
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(
                          width: 1,
                        ),
                        Text("Camera"),
                      ],
                    )),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"))
            ],
          ),
        );
      },
    );
  }

  citizenshipfield() {
    return Row(
      children: [
        const Icon(
          Icons.credit_card,
          size: 30,
          color: Color(0xFF889AAD),
        ),
        const SizedBox(width: 5),
        Text(
          'National ID (optional)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  DateTime selectedDate = DateTime.now();
  DateTime selectedDob = DateTime.now();
  Gender? selectedGender;
  final TextEditingController citizenNumber = TextEditingController();
  final TextEditingController citizenDate = TextEditingController();
  final TextEditingController issuedDistrict = TextEditingController();
  final TextEditingController citizenDob = TextEditingController();
  final TextEditingController citizenIssuedDate = TextEditingController();
  // @override
  // void initState() {
  //   citizenDob = TextEditingController();
  //   super.initState();
  // }

  citizenshipnumber() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        TextFormField(
          controller: citizenNumber,
          // validator: (value) {
          //   if (value!.isEmpty) {
          //     return 'required**';
          //   }
          //   return null;
          // },
          textAlign: TextAlign.left,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: 'National Id Number (optional)',
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(height: size.height * 0.02),
        TextFormField(
          controller: issuedDistrict,
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: 'National Id Issued District (optional)',
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(height: size.height * 0.02),
        TextFormField(
          controller: citizenIssuedDate,
          inputFormatters: [DateTextFormatter()],
          textAlign: TextAlign.left,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: 'YYYY-MM-DD',
            labelText: 'National Id Issued Date (optional)',
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        // InkWell(
        //   onTap: () async {
        //     final DateTime? picked = await showDatePicker(
        //         context: context,
        //         initialDate: DateTime.now(),
        //         firstDate: DateTime(1950),
        //         lastDate: DateTime.now());
        //     // var date = DateTime.parse(picked.toString());
        //     // var formattedDate = "${date.day}-${date.month}-${date.year}";
        //     if (picked != null) {
        //       setState(() {
        //         selectedDate = picked;
        //       });
        //     }
        //   },
        //   child: Container(
        //     padding: const EdgeInsets.only(left: 10),
        //     alignment: AlignmentDirectional.centerStart,
        //     height: 60,
        //     width: double.infinity,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(18),
        //         border: Border.all(color: Colors.black38),
        //         color: Colors.white),
        //     child: selectedDate == DateTime.now()
        //         ? const Text(
        //             'Citizenship issued date',
        //             textAlign: TextAlign.start,
        //             style: TextStyle(
        //               fontFamily: 'hello',
        //               fontSize: 18,
        //               fontWeight: FontWeight.w500,
        //               color: Colors.black54,
        //             ),
        //           )
        //         : Text(
        //             'Issued Date :  ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
        //             textAlign: TextAlign.left,
        //             style: const TextStyle(
        //                 fontFamily: 'hello',
        //                 fontSize: 18,
        //                 fontWeight: FontWeight.w500,
        //                 color: Colors.black),
        //           ),
        //   ),
        // ),
        SizedBox(height: size.height * 0.02),
        // InkWell(
        //   onTap: () async {
        //     final DateTime? picked = await showDatePicker(
        //         context: context,
        //         initialDate: DateTime.now(),
        //         firstDate: DateTime(1950),
        //         lastDate: DateTime.now());
        //     // var date = DateTime.parse(picked.toString());
        //     // var formattedDate = "${date.year}-${date.month}-${date.day}";
        //     if (picked != null) {
        //       setState(() {
        //         selectedDob = picked;
        //         print('selected date is $selectedDob');
        //       });
        //     }
        //   },
        //   child: Container(
        //     height: 60,
        //     width: double.infinity,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(18),
        //         border: Border.all(color: Colors.black38),
        //         color: Colors.white),
        //     child: Center(
        //         child: selectedDob == DateTime.now()
        //             ? const Text(
        //                 'Date Of Birth',
        //                 style: TextStyle(
        //                   fontFamily: 'hello',
        //                   fontSize: 18,
        //                   fontWeight: FontWeight.w500,
        //                   color: Colors.black54,
        //                 ),
        //               )
        //             : Text(
        //                 'DOB : ${selectedDob.year}-${selectedDob.month}-${selectedDob.day}',
        //                 style: const TextStyle(
        //                     fontFamily: 'hello',
        //                     fontSize: 18,
        //                     fontWeight: FontWeight.w500,
        //                     color: Colors.black),
        //               )),
        //   ),
        // ),
        // SizedBox(height: size.height * 0.02),
        TextFormField(
          controller: citizenDob,
          validator: (value) {
            if (value!.isEmpty) {
              return 'required**';
            }
            return null;
          },
          inputFormatters: [DateTextFormatter()],
          textAlign: TextAlign.left,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: 'YYYY-MM-DD',
            labelText: 'Date Of Birth',
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        SizedBox(height: size.height * 0.02),
        DropdownButtonFormField<Gender>(
          value: selectedGender,
          onChanged: (Gender? value) {
            setState(() {
              selectedGender = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a gender';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: 'Gender',
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
          items: Gender.values.map((Gender gender) {
            return DropdownMenuItem<Gender>(
              value: gender,
              child: Text(genderToString(gender)),
            );
          }).toList(),
        ),
        //  TextFormField(
        //   controller:citizenGender,
        //   validator: (value) {
        //     if (value!.isEmpty) {
        //       return 'required**';
        //     }
        //     return null;
        //   },
        //   textAlign: TextAlign.left,

        //   style: const TextStyle(color: Colors.black),
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        //     hintText: 'Gender',
        //     hintStyle: Theme.of(context).textTheme.titleLarge,
        //   ),
        // ),
      ],
    );
  }

  loginfiled() {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => const MainScreen());
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18), color: Colors.red),
            height: size.height * 0.067,
            width: size.width * 0.4,
            child: const Center(
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        SizedBox(width: size.width * 0.02),
        Expanded(
          child: AppButton(
            onPressed: () {
              if (selectedLatLng.value == const LatLng(27.707795, 85.343362) ||
                  selectedLatLng.value == null) {
                errorToast(msg: "Please add your location");
              } else if (_formkey.currentState!.validate() &&
                  selectedService != null &&
                  selectedGender != null) {
                CustomDialogs.fullLoadingDialog(
                    context: context,
                    data: "Registering service providerIIIIIIIIIII");
                getController.registerService(
                  email: widget.email,
                  password: widget.password,
                  mobileNumber: widget.mobileNumber,
                  jobTitle: selectedCategories!,
                  jobField: selectedService!,
                  citizenNumber: citizenNumber.text,
                  issuedDistrict: issuedDistrict.text,
                  date: citizenIssuedDate.text,
                  dateOfBirth: "${citizenDob.text}T00:00:00",
                  gender: selectedGender.toString(),
                  latitude: selectedLatLng.value!.latitude.toString(),
                  longitude: selectedLatLng.value!.longitude.toString(),
                  citizenshipFront: _citizenshipfront,
                  citizenshipBack: _citizenshipback,
                  academicImg: _academicimage,
                  associationImg: _associationimage,
                );
                // Get.to(() => PaymentScreen(), arguments: {
                //   'email': widget.email,
                //   'password': widget.password,
                //   'mobileNumber': widget.mobileNumber,
                //   'jobTitle': selectedCategories,
                //   'jobField': selectedService,
                //   'citizenNumber': citizenNumber.text,
                //   'issuedDistrict': issuedDistrict.text,
                //   'date': citizenIssuedDate.text,
                //   'dateOfBirth': "${citizenDob.text}T00:00:00",
                //   'gender': selectedGender.toString(),
                //   'latitude': selectedLatLng.value?.latitude.toString(),
                //   'longitude': selectedLatLng.value?.longitude.toString(),
                //   'citizenshipFront': _citizenshipfront,
                //   'citizenshipBack': _citizenshipback,
                //   'academicImg': _academicimage,
                //   'associationImg': _associationimage
                // });

                // getController.registerService(
                //   email: widget.email,
                //   mobileNumber: widget.mobileNumber,
                //   password: widget.password,
                //   jobField: selectedService,
                //   jobTitle: selectedCategories,
                //   citizenNumber: citizenNumber.text,
                //   issuedDistrict: issuedDistrict.text,
                //   date: citizenIssuedDate.text,
                //   dateOfBirth: "${citizenDob.text}T00:00:00",
                //   gender: selectedGender.toString(),
                //   latitude: selectedLatLng.value?.latitude.toString() ?? "",
                //   longitude: selectedLatLng.value?.longitude.toString() ?? "",
                //   citizenshipFront: _citizenshipfront!,
                //   citizenshipBack: _citizenshipback!,
                //   associationImg: _associationimage!,
                //   academicImg: _academicimage!,
                // );
                // _getController.uploadImage(_citizenshipfront, _citizenshipback,
                //     _associationimage, _academicimage);

                // getController.registerService(
                //   email: widget.email,
                //   password: widget.password,
                //   mobileNumber: widget.mobileNumber,
                //   jobTitle: selectedCategories,
                //   jobField: selectedService ?? "",
                //   citizenNumber: citizenNumber.text,
                //   issuedDistrict: issuedDistrict.text,
                //   date: citizenIssuedDate.text,
                //   dateOfBirth: "${citizenDob.text}T00:00:00",
                //   gender: selectedGender.toString(),
                //   latitude: selectedLatLng.value?.latitude.toString() ?? "",
                //   longitude: selectedLatLng.value?.longitude.toString() ?? "",
                //   citizenshipFront: _citizenshipfront ?? File(""),
                //   citizenshipBack: _citizenshipback ?? File(""),
                //   academicImg: _academicimage ?? File(""),
                //   associationImg: _associationimage ?? File(""),
                // );
              } else {
                errorToast(msg: "Please fill the fields");
              }
            },
            name: "submit",
          ),
        ),
      ],
    );
  }

  // File? _cvimage;

  // Future pickcv() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage =
  //       await imagePicker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage == null) return 'no image';

  //   setState(() {
  //     _cvimage = File(pickedImage.path);
  //   });
  // }

  File? _associationimage;

  Future pickassociation() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _associationimage = File(pickedImage.path);
        print('picked image: $_associationimage');
      });
    } else {
      print('no association picture selected');
    }
  }

  File? _academicimage;

  Future pickacademic() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _academicimage = File(pickedImage.path);
        print('picked image: $_academicimage');
      });
    } else {
      print('no academic picture selected');
    }
  }

  File? _citizenshipback;

  Future pickcitizenshipback() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return 'no citizenship back image';

    setState(() {
      _citizenshipback = File(pickedImage.path);
    });
  }

  File? _citizenshipfront;

  Future pickcitizenshipfront() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return 'no citizenship front image';

    setState(() {
      _citizenshipfront = File(pickedImage.path);
    });
  }

  String? selectedCategories;
  String? selectedService;

  ///*******Code For Google Map*******//////
  bool onpressed = false;
  GoogleMapController? googleMapController;
  final Completer<GoogleMapController> completeGoogleMapController =
      Completer();
  // LatLng selectedLatLng = const LatLng(27.707795, 85.343362);
  static const CameraPosition kGoogle = CameraPosition(
    target: LatLng(27.707795, 85.343362),
    zoom: 14.4746,
  );
  final List<Marker> marker = <Marker>[
    // const Marker(
    //     markerId: MarkerId('1'),
    //     position: LatLng(27.707795, 85.343362),
    //     infoWindow: InfoWindow(
    //       title: 'My Position',
    //     )),
  ];
  LocationPermission? permission;
  Position? position;

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  // Future<void> _getCurrentLocation() async {
  //   try {
  //     currentLocation = await location.getLocation();

  //     setState(() {
  //       _selectedLatLng = LatLng(
  //         currentLocation!.latitude!,
  //         currentLocation!.longitude!,
  //       );
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  locationButton() {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              CupertinoIcons.map,
              color: Colors.black45,
            ),
            const SizedBox(width: 5),
            Text(
              'Add Your Location',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        AppButton(
          icon: Icons.location_on,
          name: "Open Map",
          onPressed: () async {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.deniedForever) {
              await Geolocator.openAppSettings();
            } else if (permission != LocationPermission.denied &&
                permission != LocationPermission.deniedForever) {
              widget.mapController.isMapLoading.value = true;
              position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
              Get.to(() => OpenMapScreen(
                    completeGoogleMapController: completeGoogleMapController,
                    kGoogle: kGoogle,
                    marker: marker,
                    onpressed: onpressed,
                  ));
            }

            //---------------/
            // Get.to(
            //   () => OpenMapScreen(
            //     completeGoogleMapController: completeGoogleMapController,
            //     kGoogle: kGoogle,
            //     marker: marker,
            //     onpressed: onpressed,
            //   ),
            // );
            //-------------------

            // setState(() {
            //   onpressed = true;
            // });
            // getUserCurrentLocation().then((value) async {
            //   print("${value.latitude} ${value.longitude}");

            //   // // marker added for current users location
            //   // _marker.add(Marker(
            //   //   markerId: const MarkerId("2"),
            //   //   position: LatLng(value.latitude, value.longitude),
            //   //   infoWindow: const InfoWindow(
            //   //     title: 'My Current Location',
            //   //   ),
            //   // ));

            //   // specified current users location
            //   CameraPosition cameraPosition = CameraPosition(
            //     target: LatLng(value.latitude, value.longitude),
            //     zoom: 14,
            //   );

            //   final GoogleMapController controller =
            //       await completeGoogleMapController.future;
            //   controller.animateCamera(
            //       CameraUpdate.newCameraPosition(cameraPosition));
            //   setState(() {});
            // });
          },
        ),
        SizedBox(height: size.height * 0.01),
        ValueListenableBuilder(
          valueListenable: selectedLatLng,
          builder: (BuildContext context, dynamic value, Widget? child) {
            return Text(
              "Address: ${selectedLatLng.value}",
              style: const TextStyle(
                fontFamily: 'hello',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black38,
              ),
            );
          },
        ),
      ],
    );
  }

  // openMap() {
  //   Size size = MediaQuery.of(context).size;
  //   return Column(
  //     children: [
  //       // const SizedBox(height: 100),
  //       Expanded(
  //         // height: size.height * 0.795,
  //         // width: 500,
  //         // color: Colors.red,
  //         child: GoogleMap(
  //           initialCameraPosition: kGoogle,
  //           markers: Set<Marker>.of(marker),
  //           mapType: MapType.normal,
  //           myLocationEnabled: true,
  //           compassEnabled: true,
  //           onMapCreated: (GoogleMapController controller) {
  //             completeGoogleMapController.complete(controller);
  //           },
  //           onTap: (LatLng latLng) {
  //             selectedLatLng.value = latLng;
  //             setState(() {
  //               marker.clear();
  //               marker.add(
  //                 Marker(
  //                   markerId: const MarkerId('Selected Location'),
  //                   position: selectedLatLng.value,
  //                   infoWindow: InfoWindow(
  //                     title: selectedLatLng.toString(),
  //                   ),
  //                 ),
  //               );
  //             });
  //           },
  //           // onTap: (LatLng latLng) {
  //           //   setState(
  //           //     () {
  //           //       _selectedLatLng = latLng;
  //           //     },
  //           //   );
  //           // },
  //           // initialCameraPosition: currentLocation != null
  //           //     ? CameraPosition(
  //           //         target: LatLng(
  //           //           currentLocation!.latitude!,
  //           //           currentLocation!.longitude!,
  //           //         ),
  //           //         zoom: 14,
  //           //       )
  //           //     : const CameraPosition(
  //           //         target: LatLng(27.706969, 85.341963),
  //           //         zoom: 14,
  //           //       ),
  //           // initialCameraPosition: CameraPosition(
  //           //   target: _selectedLatLng,
  //           //   zoom: 14,
  //           // ),
  //           // ignore: unnecessary_null_comparison
  //           // markers: _selectedLatLng != null
  //           //     ? {
  //           //         Marker(
  //           //             markerId: const MarkerId('Selected Location'),
  //           //             position: _selectedLatLng,
  //           //             infoWindow:
  //           //                 InfoWindow(title: _selectedLatLng.toString())),
  //           //       }
  //           //     : {},
  //         ),
  //       ),
  //       Container(
  //         height: 50,
  //         width: double.infinity,
  //         color: Theme.of(context).primaryColor,
  //         child: Align(
  //           alignment: Alignment.bottomRight,
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: TextButton(
  //               style: ButtonStyle(
  //                   shape: MaterialStatePropertyAll(RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(8))),
  //                   backgroundColor:
  //                       const MaterialStatePropertyAll(Colors.blue)),
  //               child: const Text(
  //                 'Ok',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   onpressed = false;
  //                 });
  //               },
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  ///*******Code categories dropdown*******//////
  // categoriesField() {
  //   Size size = MediaQuery.of(context).size;
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           const Icon(
  //             Icons.category_outlined,
  //             size: 30,
  //             color: Color(0xFF889AAD),
  //           ),
  //           const SizedBox(width: 5),
  //           Text(
  //             'Job Title',
  //             style: Theme.of(context).textTheme.titleLarge,
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: size.height * 0.01),
  //       Container(
  //         width: double.infinity,
  //         height: size.height * 0.07,
  //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(18),
  //             border: Border.all(color: const Color(0xFF889AAD))),
  //         child: DropdownButtonHideUnderline(
  //           child: Obx(
  //             () => DropdownButton(
  //                 isExpanded: true,
  //                 menuMaxHeight: 800,
  //                 value: selectedCategories,
  //                 items: catController.products
  //                     .map((item) => DropdownMenuItem<String>(
  //                         value: item.categoryTitle.toString(),
  //                         child: Text(
  //                           item.categoryTitle.toString(),
  //                           style: const TextStyle(color: Colors.black),
  //                         )))
  //                     .toList(),
  //                 onChanged: (item) {
  //                   setState(() {
  //                     selectedCategories = item.toString();
  //                     selectedService = serviceController
  //                         .filterSubCategory[selectedCategories]?[0];
  //                   });
  //                 }),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  String genderToString(Gender gender) {
    switch (gender) {
      case Gender.Male:
        return 'Male';
      case Gender.Female:
        return 'Female';
      case Gender.Others:
        return 'Others';
    }
  }

  // categoriesJobField() {
  //   Size size = MediaQuery.of(context).size;
  //
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           const Icon(
  //             Icons.construction_outlined,
  //             size: 30,
  //             color: Color(0xFF889AAD),
  //           ),
  //           const SizedBox(width: 5),
  //           Text(
  //             'Job Field',
  //             style: Theme.of(context).textTheme.titleLarge,
  //           ),
  //         ],
  //       ),
  //       Container(
  //           width: double.infinity,
  //           height: size.height * 0.07,
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(18),
  //               border: Border.all(color: const Color(0xFF889AAD))),
  //           child: DropdownButtonHideUnderline(
  //             child: DropdownButton(
  //                 hint: const Text('Select service'),
  //                 isExpanded: true,
  //                 menuMaxHeight: 800,
  //                 value: selectedService,
  //                 items: serviceController.filterSubCategory[selectedCategories]
  //                     ?.map((item) => DropdownMenuItem<String>(
  //                         value: item,
  //                         child: Text(
  //                           item.toString(),
  //                           style: const TextStyle(color: Colors.black),
  //                         )))
  //                     .toList(),
  //                 onChanged: (item) {
  //                   setState(() {
  //                     selectedService = item.toString();
  //                   });
  //                 }),
  //           ))
  //     ],
  //   );
  // }
}

enum Gender { Male, Female, Others }

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the raw text without any formatting
    String newText = newValue.text.replaceAll('-', '') ?? '';

    // Check the length of the input text
    if (newText.length > 8) {
      newText = newText.substring(0, 8);
    }

    // Apply the formatting
    String formattedText = '';
    int index = 0;

    for (int i = 0; i < newText.length; i++) {
      formattedText += newText[i];

      if (index == 3 || index == 5) {
        formattedText += '-';
      }

      index++;
    }

    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
