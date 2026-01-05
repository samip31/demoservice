// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smartsewa/views/auth/login/login_screen.dart';

// import 'check_status.dart';

// class CheckLogin extends StatefulWidget {
//   const CheckLogin({super.key});

//   @override
//   State<CheckLogin> createState() => _CheckLoginState();
// }

// class _CheckLoginState extends State<CheckLogin> {
//   String? email;
//   check() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     email = prefs.getString('email');
//   }

//   @override
//   void initState() {
//     check();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: email == null ? const LoginScreen() : CheckStatus(),
//     );
//   }
// }
