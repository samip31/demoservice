// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/enum.dart';

import 'package:smartsewa/views/Theme/theme.dart';
import 'package:smartsewa/views/widgets/Welcome%20Screen/splashscreen.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? apptoken = prefs.getString("token");
  final bool? workStatus = prefs.getBool("workStatus");
  logger(apptoken.toString(), loggerType: LoggerType.success);

  runApp(
    MyApp(
      apptoken: apptoken,
      workStatus: workStatus,
    ),
  );
}

class MyApp extends StatelessWidget {
  // final String publicKey = 'test_public_key_ea0189443c40467c8b9a8ecc26a9c923';
  final String? apptoken;
  final bool? workStatus;
  const MyApp({
    Key? key,
    this.apptoken,
    this.workStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(dialogStyle: UpgradeDialogStyle.cupertino),
      child: KhaltiScope(
        publicKey: '${dotenv.env["KHALTI_TEST_KEY"]}',
        builder: (context, navigatorKey) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
            theme: MyTheme().appTheme(),
            debugShowCheckedModeBanner: false,
            // home: const MyScreen(),
            // home: apptoken == null
            //     ? const SplashScreen()
            //     : workStatus == true
            //         ? const WelcomeScreen()
            //         : const MainScreen(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
