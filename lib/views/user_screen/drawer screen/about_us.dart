import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/buttons/app_buttons.dart';
import '../../widgets/my_appbar.dart';

class AboutUS extends StatelessWidget {
  const AboutUS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: myAppbar(context, true, "About Us"),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Center(
              //     child: Text(
              //   "This is About Us page",
              //   style: TextStyle(fontSize: 20),
              // )),
              // app name
              const Text(
                'Smart Sewa Solutions Nepal Pvt. Ltd',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),

              SizedBox(height: size.height * 0.02),

              // description
              const Text(
                'Smart Sewa is an intermediary service-based application, offers various services on online platform via '
                'Google map-based tracking to connect clients with skilled & experienced professionals seeking specific '
                'services. The application has been developed to run on web and android system and is being developed '
                'on IOS platform. The application is equipped to provide services like plumbing, electrician, cleaning, '
                'masonry, carpeting, painting and many more which is necessary for every household in daily activities.'
                'The application is useful for skilled workers who can register themselves as service provider and normal '
                'user can benefit themselves as user to connect themselves with different service providers. '
                'Smart Sewa applications offer convenience, efficiency, reliability to users, making it easier for them to '
                'manage their household tasks and improve their quality of life. By linking you with dependable service '
                'providers for all of your household needs, our platform is made to simplify your life. We provide our '
                'users with a seamless and trouble-free experience since we recognize that handling home activities may '
                'be time-consuming and unpleasant. '
                "With just a few clicks, you can book and manage appointments using our application's simple interface. "
                'Due to the fact that we do not collect commission fees from our service providers, our application is '
                'special. We think that the money earned by our service providers for their labor should be theirs to keep '
                'in full, and that our customers should be able to take advantage of competitive prices as a result. You will '
                'always receive high-quality services because all of our service providers have been thoroughly screened '
                'and verified. ',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              // SizedBox(height: size.height * 0.02),
              // const Text(
              //   'At Smart Sewa, we provide a mobile application that serves as a bridge between service providers and service receivers. Our platform acts as a mediator, connecting individuals and businesses offering services with those seeking them. It is important to understand that we do not provide any services ourselves. Instead, we facilitate connections and transactions between service providers and service receivers.',
              //   style: TextStyle(fontSize: 18),
              // ),
              // SizedBox(height: size.height * 0.02),
              // const Text(
              //   "Thank you for choosing Smart Sewa Solutions Nepal Pvt. Ltd. We are dedicated to providing a reliable platform that connects individuals and businesses, making service provision more accessible. Should you have any further questions or concerns, please don't hesitate to contact us.",
              //   style: TextStyle(fontSize: 18),
              // ),
              // SizedBox(height: size.height * 0.02),
              // const Text(
              //   'Best regards,',
              //   style: TextStyle(fontSize: 18),
              // ),
              SizedBox(
                height: size.height * 0.01,
              ),
              const Text(
                'We are dedicated to provide exceptional customer service, and our support staff is always accessible to '
                'assist you with any questions or problems. With regard to relations with service providers and price, the '
                'Smart Sewa application is made to allow users as much options as possible. Users can freely negotiate '
                "prices with service providers since we don't include any work fees in our platform. "
                "We are passionate about improving people's lives by streamlining domestic chores and freeing up time "
                'for the important things. Experience the ease of use and effectiveness of our mobile home service '
                'application by becoming a member of our community now. ',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18,
                  // color: Colors.green,
                ),
              ),

              SizedBox(height: size.height * 0.03),
              AppButton(
                  name: "Back",
                  onPressed: () {
                    Get.back();
                  }),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
