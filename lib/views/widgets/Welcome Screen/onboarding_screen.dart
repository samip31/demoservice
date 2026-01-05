import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../auth/login/login_screen.dart';
import 'onboardingscreen_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLastPage = false;
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        onPageChanged: (value) {
          setState(() => isLastPage = value == 3);
        },
        controller: controller,
        children: const [
          BuildScreen(
            name: "Welcome",
            desc:
                "Welcome to Smart Sewa, where finding the right talent is just"
                " a click away. Connect with skilled professionals and revolutionize your hiring process.",
            images: "5.png",
          ),
          BuildScreen(
            name: "Qualified Workers",
            desc: "The complete solution for human resource problem providing "
                "placement services, skills development programs, professional courses, recruitment.",
            images: "1.png",
          ),
          BuildScreen(
            name: "Every Solution",
            desc: "Utilize all resources and be creative in problem-solving. "
                "Stay determined and persistent in finding the best solution.",
            images: "2.png",
          ),
          BuildScreen(
            name: "Your Price",
            desc: "Connect to service provider through app & Pick the price "
                "that suits you best. No additional cost involved.",
            images: "4.png",
          ),
        ],
      ),
      bottomSheet: Container(
        height: 140,
        color: Colors.white,
        child: isLastPage
            ? Align(
                alignment: Alignment.topCenter,
                child: InkWell(
                  onTap: () {
                    Get.to(() => const LoginScreen());
                  },
                  child: Container(
                    height: 65,
                    width: 220,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white),
                        color: Colors.greenAccent),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.greenAccent,
                        child: IconButton(
                          onPressed: () => controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          ),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: controller,
                        count: 4,
                        effect: const SwapEffect(
                          dotHeight: 16,
                          dotWidth: 16,
                          type: SwapType.normal,
                          strokeWidth: 5,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.greenAccent,
                        child: IconButton(
                          onPressed: () => controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          ),
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => controller.jumpToPage(3),
                    child: const Text('Skip'),
                  )
                ],
              ),
      ),
    );
  }
}
