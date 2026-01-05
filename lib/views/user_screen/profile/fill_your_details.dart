// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:smartsewa/network/services/authApi.dart';
// import 'package:smartsewa/views/widgets/my_appbar.dart';
// import 'package:smartsewa/views/widgets/textfield_box/string_textfield.dart';
// import '../../../network/models/user_Models.dart';
// import '../../../view_model/auth_controller.dart';
// import '../../../network/services/remote_Services.dart';
// import '../../widgets/buttons/app_buttons.dart';
// import '../../widgets/customalert.dart';
// import '../../widgets/textfield_box/email_textfield.dart';
// import '../approval/citizenshipimagebox.dart';
// import '../main_screen.dart';
//
// class FillDetail extends StatefulWidget {
//   const FillDetail({Key? key}) : super(key: key);
//
//   @override
//   State<FillDetail> createState() => _FillDetailState();
// }
//
// class _FillDetailState extends State<FillDetail> {
//   final emailController = MyTextController().emailController;
//   final companyController = MyTextController().companyNameController;
//   final citizenshipNumberController =
//       MyTextController().citizenshipNumberController;
//   final userDetails = AuthApi();
//   Future<Post>? _futureAlbum;
//   final _formkey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: myAppbar(context, true),
//       body: Form(
//         key: _formkey,
//         child: Column(
//           children: [
//             SizedBox(height: size.height * 0.01),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(30),
//                     topLeft: Radius.circular(30),
//                   ),
//                   color: Colors.white,
//                 ),
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: EdgeInsets.all(size.aspectRatio * 55),
//                     child: decorfiled(),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   decorfiled() {
//     Size size = MediaQuery.of(context).size;
//     return Column(
//       children: [
//         Text(
//           'Fill Your Details',
//           style: Theme.of(context).textTheme.headline1,
//         ),
//         SizedBox(height: size.height * 0.02),
//         EmailTextField(
//           controller: emailController,
//         ),
//         SizedBox(height: size.height * 0.02),
//         StringTextField(
//             controller: companyController,
//             name: 'Company Name',
//             box_icon: Icons.business,
//             hintText: 'Abc Company Limited'),
//         SizedBox(height: size.height * 0.02),
//         citizenshipfield(),
//         SizedBox(height: size.height * 0.02),
//         CitizenshipImageBox(
//             image: _citizenshipfront,
//             onTap: () {
//               pickcitizenshipfront(ImageSource.gallery);
//             },
//             hinttext: ''
//                 'Upload Citizenship Front'),
//         SizedBox(height: size.height * 0.02),
//         CitizenshipImageBox(
//             image: _citizenshipback,
//             onTap: () {
//               pickcitizenshipback(ImageSource.gallery);
//             },
//             hinttext: 'Upload Citizenship Back'),
//         SizedBox(height: size.height * 0.02),
//         citizenshipnumber(),
//         SizedBox(height: size.height * 0.03),
//         loginfiled(),
//       ],
//     );
//   }
//
//   citizenshipfield() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Icon(
//               Icons.credit_card,
//               size: 30,
//               color: Color(0xFF889AAD),
//             ),
//             SizedBox(width: 5),
//             Text(
//               'Citizenship',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   citizenshipnumber() {
//     Size size = MediaQuery.of(context).size;
//
//     return Column(
//       children: [
//         TextFormField(
//           controller: citizenshipNumberController,
//           textAlign: TextAlign.left,
//           keyboardType: TextInputType.phone,
//           style: TextStyle(color: Colors.black),
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
//             hintText: 'Citizenship Number',
//             hintStyle: Theme.of(context).textTheme.headline6,
//           ),
//         ),
//         SizedBox(height: size.height * 0.02),
//         TextFormField(
//           textAlign: TextAlign.left,
//           keyboardType: TextInputType.phone,
//           style: TextStyle(color: Colors.black),
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
//             hintText: 'Citizenship Issue Date',
//             hintStyle: Theme.of(context).textTheme.headline6,
//           ),
//         ),
//       ],
//     );
//   }
//
//   loginfiled() {
//     Size size = MediaQuery.of(context).size;
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         InkWell(
//             // onTap: () {
//             //   MyDialogs().myAlert(context, 'ram', 'Hello', () {
//             //     Get.back();
//             //   }, () {
//             //     Get.offAll(MainScreen());
//             //   });
//             // },
//             child: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(18), color: Colors.red),
//           height: size.height * 0.067,
//           width: size.width * 0.4,
//           child: Center(
//             child: Text(
//               'Cancel',
//               style: TextStyle(
//                   fontSize: 21,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500),
//             ),
//           ),
//         )),
//         SizedBox(width: size.width * 0.02),
//         Expanded(
//           child: AppButton(
//               name: 'Submit',
//               onPressed: () {
//                 if (_formkey.currentState!.validate()) {
//                   MyDialogs().myAlert(context, 'Submit Details',
//                       'Are you sure, you want to submit?', () {
//                     Get.back();
//                   }, () {
//                     setState(() {
//                       _futureAlbum = userDetails.userDetails(
//                           emailController.text,
//                           companyController.text,
//                           citizenshipNumberController.text);
//                     });
//                     Get.offAll(MainScreen());
//                   });
//                 }
//               }),
//         ),
//       ],
//     );
//   }
//
//   File? _citizenshipback;
//   Future pickcitizenshipback(ImageSource) async {
//     final image = await ImagePicker().pickImage(source: ImageSource);
//     if (image == null) return;
//
//     final imageTemporary = File(image.path);
//     setState(() {
//       this._citizenshipback = imageTemporary;
//     });
//   }
//
//   File? _citizenshipfront;
//   Future pickcitizenshipfront(ImageSource) async {
//     final image = await ImagePicker().pickImage(source: ImageSource);
//     if (image == null) return;
//
//     final imageTemporary = File(image.path);
//     setState(() {
//       this._citizenshipfront = imageTemporary;
//     });
//   }
// }
