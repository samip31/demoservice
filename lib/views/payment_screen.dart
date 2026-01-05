// import 'package:esewa_flutter_sdk/esewa_config.dart';
// import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
// import 'package:esewa_flutter_sdk/esewa_payment.dart';
// import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:smartsewa/core/enum.dart';
import 'package:smartsewa/network/services/authServices/register_service.dart';
import 'package:smartsewa/network/services/exraServices/payment_controller.dart';
import 'package:smartsewa/views/widgets/buttons/app_buttons.dart';
import 'package:smartsewa/views/widgets/custom_snackbar.dart';
import 'package:smartsewa/views/widgets/custom_text.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

import '../core/development/console.dart';
import '../core/states.dart';
import '../payment.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({
    super.key,
  });
  final Map<String, dynamic>? data = Get.arguments;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final getController = Get.put(RegisterServiceController());
  final paymentController = Get.put(PaymentController());
  bool showDueAmount = false;
  void submit() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to submit the payment?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        selectedPaymentDurationService.value = null;
        selectedPaymentMethod.value = null;
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: myAppbar(
            context,
            false,
            '',
            leading: GestureDetector(
              onTap: () {
                selectedPaymentDurationService.value = null;
                selectedPaymentMethod.value = null;
                Get.back();
              },
              child: const Icon(Icons.arrow_back),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(size.aspectRatio * 55),
              child: Column(
                children: [
                  Text(
                    'PaymentStatus Mode',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(height: size.height * 0.02),
                  // paymentfield(),
                  Column(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: selectedPaymentDurationService,
                        builder: (context, value, child) =>
                            DropdownButtonFormField<PeriodData>(
                          value: value,
                          onChanged: (PeriodData? val) {
                            setState(() {
                              selectedPaymentDurationService.value = val;
                              paymentController.amountField.text =
                                  getAmountForPeriodService(period: val)
                                      .toString();
                              // paymentController.amountField.text =
                              //     getAmountForPeriod(value).toString();
                            });
                          },
                          validator: (val) {
                            if (val == null) {
                              return 'Please select a period';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            hintText: 'No. of years',
                            hintStyle: Theme.of(context).textTheme.titleLarge,
                          ),
                          items: PeriodData.values.map((PeriodData period) {
                            return DropdownMenuItem<PeriodData>(
                              value: period,
                              child: Text(
                                periodToStringService(period: period),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // SizedBox(height: size.height * 0.02),
                      // TextFormField(
                      //   readOnly: true,
                      //   controller: paymentController.amountField,
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'required**';
                      //     }
                      //     return null;
                      //   },
                      //   textAlign: TextAlign.left,
                      //   keyboardType: TextInputType.phone,
                      //   style: const TextStyle(color: Colors.black),
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(18),
                      //     ),
                      //     hintText: 'Amount',
                      //     hintStyle: Theme.of(context).textTheme.titleLarge,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  // SizedBox(
                  //   height: size.height * 0.067,
                  //   width: double.infinity,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(18),
                  //     child: ElevatedButton(
                  //         style: ElevatedButton.styleFrom(
                  //             backgroundColor: Theme.of(context).primaryColor),
                  //         onPressed: () {
                  //           setState(() {
                  //             showDueAmount = true;
                  //           });
                  //           openPromoCodeDialog();
                  //         },
                  //         child: const Text('Use Promo Code')),
                  //   ),
                  // ),
                  TextFormField(
                    controller: paymentController.promoCodeField,
                    // initialValue: dueAmount,
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'required**';
                    //   }
                    //   return null;
                    // },
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      suffix: CustomText.ourText(
                        "50% off",
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      hintText: 'Promo code',
                      hintStyle: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  // SizedBox(height: size.height * 0.02),
                  // if (showDueAmount)
                  //   TextFormField(
                  //     controller: dueAmountField,
                  //     readOnly: true,
                  //     // initialValue: dueAmount,
                  //     // validator: (value) {
                  //     //   if (value!.isEmpty) {
                  //     //     return 'required**';
                  //     //   }
                  //     //   return null;
                  //     // },
                  //     textAlign: TextAlign.left,
                  //     keyboardType: TextInputType.phone,
                  //     style: const TextStyle(color: Colors.black),
                  //     decoration: InputDecoration(
                  //       border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(18)),
                  //       hintText: 'Due Amount',
                  //       hintStyle: Theme.of(context).textTheme.titleLarge,
                  //     ),
                  //   ),
                  SizedBox(height: size.height * 0.02),
                  // DropdownButtonFormField<PaymentStatus>(
                  //   value: selectedPayment,
                  //   onChanged: (PaymentStatus? value) {
                  //     setState(() {
                  //       selectedPayment = value;
                  //     });
                  //   },
                  //   validator: (value) {
                  //     if (value == null) {
                  //       return 'Please select a payment';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(18)),
                  //     hintText: 'PaymentStatus through',
                  //     hintStyle: Theme.of(context).textTheme.titleLarge,
                  //   ),
                  //   items: PaymentStatus.values.map((PaymentStatus payment) {
                  //     return DropdownMenuItem<PaymentStatus>(
                  //       value: payment,
                  //       child: Text(paymentToString(payment)),
                  //     );
                  //   }).toList(),
                  // ),
                  ValueListenableBuilder(
                    valueListenable: selectedPaymentMethod,
                    builder: (context, value, child) =>
                        DropdownButtonFormField<PaymentMethod>(
                      value: value,
                      onChanged: (PaymentMethod? val) {
                        selectedPaymentMethod.value = val;
                      },
                      validator: (val) {
                        if (val == null) {
                          return 'Please select a payment';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                        hintText: 'Payment through',
                        hintStyle: Theme.of(context).textTheme.titleLarge,
                      ),
                      items: PaymentMethod.values.map((PaymentMethod payment) {
                        return DropdownMenuItem<PaymentMethod>(
                          value: payment,
                          child: Row(
                            children: [
                              paymentToString(payment: payment) == "Khalti"
                                  ? Image.asset(
                                      "assets/khalti_logo.jpeg",
                                      height: 30,
                                      width: 30,
                                    )
                                  : Image.asset(
                                      "assets/esewa_logo.png",
                                      height: 30,
                                      width: 30,
                                    ),
                              Text(
                                paymentToString(payment: payment),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      CustomText.ourText(
                        "Total Price: ",
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText.ourText(
                        getAmountForPeriodService(
                            period: selectedPaymentDurationService.value),
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  Obx(
                    () => paymentController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : getController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : AppButton(
                                name: 'Submit',
                                onPressed: () {
                                  // getController.registerService(
                                  //   email: widget.data['email'],
                                  //   password: widget.data['password'],
                                  //   mobileNumber: widget.data['mobileNumber'],
                                  //   jobTitle: widget.data['jobTitle'],
                                  //   jobField: widget.data['jobField'],
                                  //   citizenNumber: widget.data['citizenNumber'],
                                  //   issuedDistrict: widget.data['issuedDistrict'],
                                  //   date: widget.data['date'],
                                  //   dateOfBirth: widget.data['dateOfBirth'],
                                  //   gender: widget.data['gender'],
                                  //   latitude: widget.data['latitude'],
                                  //   longitude: widget.data['longitude'],
                                  //   citizenshipFront: widget.data['citizenshipFront'],
                                  //   citizenshipBack: widget.data['citizenshipBack'],
                                  //   academicImg: widget.data['academicImg'],
                                  //   associationImg: widget.data['associationImg'],
                                  // );
                                  var uniqueKhaltiId =
                                      "${DateTime.now().millisecondsSinceEpoch}";
                                  if (paymentController
                                          .amountField.text.isNotEmpty &&
                                      selectedPaymentDurationService.value !=
                                          null &&
                                      selectedPaymentMethod.value != null) {
                                    paymentController
                                        .uploadPaymentInitiate(
                                            isFromService: true)
                                        .then((value) {
                                      if (value != null) {
                                        if (selectedPaymentMethod.value ==
                                            PaymentMethod.khalti) {
                                          KhaltiScope.of(context).pay(
                                            config: PaymentConfig(
                                                // amount: int.parse(
                                                //     ((double.parse(value)) * 100)
                                                //         .round()
                                                //         .toString()),
                                                amount: 1000,
                                                productIdentity: uniqueKhaltiId,
                                                productName:
                                                    "Service Provider Name - ID "),
                                            preferences: [
                                              PaymentPreference.khalti,
                                            ],
                                            onSuccess: (su) {
                                              // CustomDialogs.fullLoadingDialog(
                                              //     context: context);
                                              paymentController
                                                  .uploadPaymentService()
                                                  .then((value) {
                                                consolelog(
                                                    "value data :: $value");
                                                if (value == true) {
                                                  selectedPaymentDurationService
                                                      .value = null;
                                                  selectedPaymentMethod.value =
                                                      null;
                                                  getController.registerService(
                                                    email:
                                                        widget.data?['email'],
                                                    password: widget
                                                        .data?['password'],
                                                    mobileNumber: widget
                                                        .data?['mobileNumber'],
                                                    jobTitle: widget
                                                        .data?['jobTitle'],
                                                    jobField: widget
                                                        .data?['jobField'],
                                                    citizenNumber: widget
                                                        .data?['citizenNumber'],
                                                    issuedDistrict:
                                                        widget.data?[
                                                            'issuedDistrict'],
                                                    date: widget.data?['date'],
                                                    dateOfBirth: widget
                                                        .data?['dateOfBirth'],
                                                    gender:
                                                        widget.data?['gender'],
                                                    latitude: widget
                                                        .data?['latitude'],
                                                    longitude: widget
                                                        .data?['longitude'],
                                                    citizenshipFront:
                                                        widget.data?[
                                                            'citizenshipFront'],
                                                    citizenshipBack:
                                                        widget.data?[
                                                            'citizenshipBack'],
                                                    academicImg: widget
                                                        .data?['academicImg'],
                                                    associationImg:
                                                        widget.data?[
                                                            'associationImg'],
                                                  );
                                                }
                                              }).catchError((err) {
                                                logger(err,
                                                    loggerType:
                                                        LoggerType.error);
                                                errorToast(
                                                    msg:
                                                        "Error in uploading payment data");
                                              });
                                            },
                                            onFailure: (fa) {
                                              errorToast(msg: 'Payment Failed');
                                            },
                                            onCancel: () {
                                              errorToast(
                                                  msg: 'Payment Cancelled');
                                            },
                                          );
                                        } else if (selectedPaymentMethod
                                                .value ==
                                            PaymentMethod.esewa) {
                                          // Get.to(() => const EsewaPaymentScreen());
                                          // try {
                                          //   EsewaFlutterSdk.initPayment(
                                          //     esewaConfig: EsewaConfig(
                                          //       environment: Environment.live,
                                          //       clientId:
                                          //           "${dotenv.env["ESEWA_CLIENT_ID"]}",
                                          //       secretId:
                                          //           "${dotenv.env["ESEWA_SECRET_KEY"]}",
                                          //     ),
                                          //     esewaPayment: EsewaPayment(
                                          //       productId: "smartsewa",
                                          //       productName: "Service Provider",
                                          //       productPrice: "10",
                                          //     ),
                                          //     onPaymentSuccess:
                                          //         (EsewaPaymentSuccessResult
                                          //             data) {
                                          //       debugPrint(
                                          //           ":::SUCCESS::: => $data");
                                          //       paymentController
                                          //           .uploadPaymentService()
                                          //           .then((value) {
                                          //         if (value) {
                                          //           selectedPaymentDurationService
                                          //               .value = null;
                                          //           selectedPaymentMethod
                                          //               .value = null;
                                          //           getController
                                          //               .registerService(
                                          //             email:
                                          //                 widget.data?['email'],
                                          //             password: widget
                                          //                 .data?['password'],
                                          //             mobileNumber:
                                          //                 widget.data?[
                                          //                     'mobileNumber'],
                                          // jobTitle: widget
                                          //     .data?['jobTitle'],
                                          // jobField: widget
                                          //     .data?['jobField'],
                                          // citizenNumber:
                                          //     widget.data?[
                                          //         'citizenNumber'],
                                          // issuedDistrict:
                                          //     widget.data?[
                                          //         'issuedDistrict'],
                                          // date:
                                          //     widget.data?['date'],
                                          // dateOfBirth: widget
                                          //     .data?['dateOfBirth'],
                                          // gender: widget
                                          //     .data?['gender'],
                                          // latitude: widget
                                          //     .data?['latitude'],
                                          // longitude: widget
                                          //     .data?['longitude'],
                                          // citizenshipFront: widget
                                          //         .data?[
                                          //     'citizenshipFront'],
                                          // citizenshipBack: widget
                                          //         .data?[
                                          //     'citizenshipBack'],
                                          // academicImg: widget
                                          //     .data?['academicImg'],
                                          // associationImg:
                                          //     widget.data?[
                                          //         'associationImg'],
                                          //           );
                                          //         }
                                          //       }).catchError((err) {
                                          //         //  back(context);
                                          //         consolelog(err.toString());
                                          //         errorToast(
                                          //             msg:
                                          //                 "Error in uploading payment data");
                                          //       });
                                          //     },
                                          //     onPaymentFailure: (data) {
                                          //       debugPrint(
                                          //           ":::FAILURE::: => $data");
                                          //       errorToast(
                                          //           msg: "${data.message}");
                                          //     },
                                          //     onPaymentCancellation: (data) {
                                          //       debugPrint(
                                          //           ":::CANCELLATION::: => $data");
                                          //       errorToast(
                                          //           msg: "${data.message}");
                                          //     },
                                          //   );
                                          // } on Exception catch (e) {
                                          //   debugPrint(
                                          //       "EXCEPTION : ${e.toString()}");
                                          // }
                                        }
                                      }
                                    });
                                  } else {
                                    CustomSnackBar.showSnackBar(
                                        title: "Please fill",
                                        color: Colors.red);
                                  }
                                  consolelog("args:::::${widget.data}");

                                  // submit();
                                }),
                  )
                ],
              ),
            ),
          )),
    );
  }

  // Period? selectedPeriod;
  // String dueAmount = '';
  // PaymentStatus? selectedPayment;

  // final TextEditingController amountField = TextEditingController();
  final TextEditingController promoCodeField = TextEditingController();
  final TextEditingController dueAmountField = TextEditingController();
  @override
  void initState() {
    super.initState();
    // dueAmountField.text = dueAmount;
  }

  @override
  void dispose() {
    // amountField.dispose();
    promoCodeField.dispose();
    dueAmountField.dispose();
    super.dispose();
  }

  // paymentfield() {
  //   Size size = MediaQuery.of(context).size;

  //   return Column(
  //     children: [
  //       DropdownButtonFormField<Period>(
  //         value: selectedPeriod,
  //         onChanged: (Period? value) {
  //           setState(() {
  //             selectedPeriod = value;
  //             amountField.text = getAmountForPeriod(value).toString();
  //           });
  //         },
  //         validator: (value) {
  //           if (value == null) {
  //             return 'Please select a period';
  //           }
  //           return null;
  //         },
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
  //           hintText: 'No. of years',
  //           hintStyle: Theme.of(context).textTheme.titleLarge,
  //         ),
  //         items: Period.values.map((Period period) {
  //           return DropdownMenuItem<Period>(
  //             value: period,
  //             child: Text(periodToString(period)),
  //           );
  //         }).toList(),
  //       ),
  //       SizedBox(height: size.height * 0.02),
  //       TextFormField(
  //         readOnly: true,
  //         controller: amountField,
  //         validator: (value) {
  //           if (value!.isEmpty) {
  //             return 'required**';
  //           }
  //           return null;
  //         },
  //         textAlign: TextAlign.left,
  //         keyboardType: TextInputType.phone,
  //         style: const TextStyle(color: Colors.black),
  //         decoration: InputDecoration(
  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
  //           hintText: 'Amount',
  //           hintStyle: Theme.of(context).textTheme.titleLarge,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // String paymentToString(PaymentMethod payment) {
  //   switch (payment) {
  //     case PaymentMethod.khalti:
  //       return 'Khalti';
  //     // case PaymentMethod.esewa:
  //     //   return 'E-Sewa';
  //   }
  // }

  String periodToString(PeriodData period) {
    switch (period) {
      case PeriodData.fdays:
        return '1 year';
      // case Period.sdays:
      //   return '';
      // case Period.tdays:
      //   return '';
      default:
        return '0 year';
    }
  }

  String getAmountForPeriod(PeriodData? period) {
    switch (period) {
      case PeriodData.fdays:
        return 'Rs 1000';
      // case Period.sdays:
      //   return 'Rs 2000';
      // case Period.tdays:
      //   return 'Rs 3000';
      default:
        return '0';
    }
  }

  void openPromoCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Promo Code'),
          content: TextField(
            controller: promoCodeField,
            decoration: const InputDecoration(
              hintText: 'Enter promo code',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Calculate discounted amount based on promo code
                  // dueAmount = calculateDiscountedAmount(
                  //     amountField.text, promoCodeField.text);
                  updateDueAmount();
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  String calculateDiscountedAmount(String amount, String promoCode) {
    // Logic to calculate discounted amount based on the promo code

    if (promoCode == 'smartsewa') {
      double originalAmount = double.parse(amount.replaceAll('Rs ', ''));
      double discount = originalAmount * 0.5;
      double discountedAmount = originalAmount - discount;
      return 'Rs ${discountedAmount.toStringAsFixed(0)}';
    } else {
      return amount;
    }
  }

  void updateDueAmount() {
    // Update the due amount based on the selected period and promo code
    // String amount = amountField.text;
    // dueAmount = calculateDiscountedAmount(amount, promoCodeField.text);
    // dueAmountField.text = dueAmount;
  }
}
