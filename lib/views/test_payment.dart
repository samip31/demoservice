import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:smartsewa/network/services/categories&services/categories_controller.dart';
import 'package:smartsewa/network/services/exraServices/payment_controller.dart';

class TestPaymentScreen extends StatefulWidget {
  const TestPaymentScreen(
      {Key? key, this.paymentAmount, required this.serviceType})
      : super(key: key);

  final paymentAmount;
  final String serviceType;

  @override
  State<TestPaymentScreen> createState() => _TestPaymentScreenKhalti();
}

class _TestPaymentScreenKhalti extends State<TestPaymentScreen> {
  final paymentController = Get.put(PaymentController());
  TextEditingController amountController = TextEditingController();
  int amount = 0;

  @override
  void initState() {
    super.initState();
    amount = widget.paymentAmount;
  }

  final catController = Get.put(CatController());
  String? selectedItem;

  getAmt() {
    if (widget.paymentAmount != 0) {
      return int.parse(widget.paymentAmount.toString()) * 100;
    } else {
      return int.parse(amountController.text) * 100;
    }
  }

  String convertedDateTime =
      "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} "
      "${DateTime.now().hour.toString().padLeft(2, '0')}-${DateTime.now().minute.toString().padLeft(
            2,
            '0',
          )}";

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(size.aspectRatio * 30),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              const Text(
                "Payment",
                style: TextStyle(
                  fontFamily: 'hello',
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter a valid amount";
                  }
                  return null;
                },
                controller: widget.paymentAmount != 0
                    ? TextEditingController(
                        text: widget.paymentAmount.toString())
                    : amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter Amount to pay",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  // hintText:
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 15),
              // const Text(
              //   "Choose Your Service :",
              //   style: TextStyle(
              //     fontFamily: 'hello',
              //     fontSize: 18,
              //     fontWeight: FontWeight.w500,
              //     color: Colors.white,
              //   ),
              // ),
              // const SizedBox(height: 15),
              // Container(
              //   width: double.infinity,
              //   height: size.height * 0.07,
              //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(color: const Color(0xFF889AAD))),
              //   child: DropdownButtonHideUnderline(
              //     child: Obx(
              //       () {
              //         if (catController.isLoading.value) {
              //           return const Center(
              //             child: CircularProgressIndicator(),
              //           );
              //         } else {
              //           return DropdownButton(
              //               menuMaxHeight: 800,
              //               value: selectedItem ??
              //                   catController.products[0].categoryTitle,
              //               items: catController.products
              //                   .map((item) => DropdownMenuItem<String>(
              //                       value: item.categoryTitle.toString(),
              //                       child: Text(
              //                         item.categoryTitle.toString(),
              //                         style: const TextStyle(color: Colors.white),
              //                       )))
              //                   .toList(),
              //               onChanged: (item) {
              //                 setState(() {
              //                   selectedItem = item.toString();
              //                 });
              //               });
              //         }
              //       },
              //     ),
              //   ),
              // ),
              const Spacer(),
              MaterialButton(
                onPressed: onPressed,
                splashColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    width: double.infinity,
                    color: const Color(0XFF56328c),
                    child: const Center(
                      child: Text(
                        'Pay with Khalti',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPressed() {
    if (formKey.currentState!.validate()) {
      KhaltiScope.of(context).pay(
        config: PaymentConfig(
            amount: getAmt(),
            productIdentity: 'dells',
            productName: selectedItem.toString()),
        preferences: [
          PaymentPreference.khalti,
        ],
        onSuccess: (su) {
          paymentController.uploadPayment(serviceType: widget.serviceType);
          const successSnackBar = SnackBar(
            content: Text('Payment Successful'),
          );
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
          // if (widget.serviceType == 'offer') {
          //   Get.to(() => const UploadOffer());
          // } else if (widget.serviceType == 'vacancy') {
          //   Get.to(() => const UploadVaccancy());
          // } else {
          //   Get.to(() => const UploadSecondHand());
          // }
        },
        onFailure: (fa) {
          const failedSnackBar = SnackBar(
            content: Text('Payment Failed'),
          );
          ScaffoldMessenger.of(context).showSnackBar(failedSnackBar);
        },
        onCancel: () {
          const cancelSnackBar = SnackBar(
            content: Text('Payment Cancelled'),
          );
          ScaffoldMessenger.of(context).showSnackBar(cancelSnackBar);
        },
      );
    }
  }
}
