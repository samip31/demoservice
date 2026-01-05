import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/views/auth/login/login_screen.dart';
import 'package:smartsewa/views/user_screen/main_screen.dart';
import 'package:smartsewa/views/widgets/Welcome%20Screen/welcome_screen.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';

import '../../core/enum.dart';
import '../../views/widgets/Welcome Screen/onboarding_screen.dart';

class SplashController extends GetxController {
  checkScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    logger("rememberMe :: ${preferences.getBool("rememberMe")}",
        loggerType: LoggerType.success);
    logger("Token :: ${preferences.getBool("workStatus")}",
        loggerType: LoggerType.error);
    try {
      selectedAutoLogin.value = preferences.getBool("rememberMe");
      logger("iam in splash controller");

      if (preferences.getBool("rememberMe") ?? false) {
        if (preferences.getString("token") == null) {
          if (preferences.getBool('first_login') ?? true) {
            await preferences.setBool('first_login', false);
            Get.offAll(() => const OnBoardingScreen());
          } else {
            await preferences.setBool('first_login', false);
            Get.offAll(() => const LoginScreen());
          }
          // await Get.off(() => const PermissionScreen(token: "token"));
        } else if (preferences.getBool("workStatus") ?? false) {
          Get.offAll(() => const WelcomeScreen());
        } else {
          Get.offAll(() => const MainScreen());
        }
      } else {
        await preferences.remove('token');
        await preferences.remove('id');
        await preferences.remove('workStatus');
        await preferences.setBool('rememberMe', false);
        if (preferences.getBool('first_login') ?? true) {
          await preferences.setBool('first_login', false);
          Get.offAll(() => const OnBoardingScreen());
        } else {
          await preferences.setBool('first_login', false);
          Get.offAll(() => const LoginScreen());
        }
        // Get.offAll(() => const LoginScreen());
      }
    } catch (err) {
      errorToast(msg: err.toString());
    }
  }
}
