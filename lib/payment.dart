import 'dart:io';

// import 'package:esewa_flutter_sdk/esewa_config.dart';
// import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
// import 'package:esewa_flutter_sdk/esewa_payment.dart';
// import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:smartsewa/core/development/console.dart';

import 'package:smartsewa/core/states.dart';
import 'package:smartsewa/network/services/exraServices/market_controller.dart';
import 'package:smartsewa/network/services/exraServices/offer_controller.dart';
import 'package:smartsewa/network/services/exraServices/payment_controller.dart';
import 'package:smartsewa/network/services/exraServices/vacancy_controller.dart';
import 'package:smartsewa/views/widgets/buttons/app_buttons.dart';
import 'package:smartsewa/views/widgets/custom_text.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

import 'network/services/authServices/register_service.dart';

String paymentToString({PaymentMethod? payment}) {
  switch (payment) {
    case PaymentMethod.khalti:
      return 'Khalti';
    case PaymentMethod.esewa:
      return 'E-Sewa';
    default:
      return "Khalti";
  }
}

String periodToStringService({PeriodData? period}) {
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

String periodToStringInDaysService({PeriodData? period}) {
  switch (period) {
    case PeriodData.fdays:
      return '365 days';
    // case Period.sdays:
    //   return '';
    // case Period.tdays:
    //   return '';
    default:
      return '0 days';
  }
}

String getAmountForPeriodService({PeriodData? period}) {
  switch (period) {
    case PeriodData.fdays:
      return '1000';
    // case Period.sdays:
    //   return 'Rs 2000';
    // case Period.tdays:
    //   return 'Rs 3000';
    default:
      return '0';
  }
}

String periodToString({Period? period}) {
  switch (period) {
    case Period.fdays:
      return '7 days';
    case Period.sdays:
      return '15 days';
    case Period.tdays:
      return '30 days';
    default:
      return "0 days";
  }
}

String getAmountForPeriod(Period? period) {
  switch (period) {
    case Period.fdays:
      return '1000';
    case Period.sdays:
      return '2000';
    case Period.tdays:
      return '3000';
    default:
      return '0';
  }
}

String getOfferAmountForPeriod(Period? period) {
  switch (period) {
    case Period.fdays:
      return '500';
    case Period.sdays:
      return '1000';
    case Period.tdays:
      return '1500';
    default:
      return '0';
  }
}

String getMarketAmountForPeriod(Period? period) {
  switch (period) {
    case Period.fdays:
      return '50';
    case Period.sdays:
      return '100';
    case Period.tdays:
      return '150';
    default:
      return '0';
  }
}

String getVacancyAmountForPeriod(Period? period) {
  switch (period) {
    case Period.fdays:
      return '500';
    case Period.sdays:
      return '1000';
    case Period.tdays:
      return '1500';
    default:
      return '0';
  }
}

enum PeriodData {
  fdays,
}

// enum PaymentStatus { khalti }

enum Period { fdays, sdays, tdays }

enum PaymentMethod { khalti, esewa }

class Payment extends StatefulWidget {
  final String serviceType;
  final File? pickedImage;
  final bool? isFromServiceScreen;
  const Payment({
    Key? key,
    required this.serviceType,
    this.pickedImage,
    this.isFromServiceScreen,
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final getController = Get.put(RegisterServiceController());
  final paymentController = Get.put(PaymentController());
  final marketController = Get.put(MarketController());
  final offerController = Get.put(OfferController());
  final vacancyController = Get.put(VacancyController());

  @override
  void initState() {
    super.initState();
  }

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

  // String calculateDiscountedAmount(String amount, String promoCode) {
  //   // Logic to calculate discounted amount based on the promo code

  //   if (promoCode == 'smartsewa') {
  //     double originalAmount = double.parse(amount.replaceAll('Rs ', ''));
  //     double discount = originalAmount * 0.5;
  //     double discountedAmount = originalAmount - discount;
  //     return 'Rs ${discountedAmount.toStringAsFixed(0)}';
  //   } else {
  //     return amount;
  //   }
  // }

  // void updateDueAmount() {
  //   // Update the due amount based on the selected period and promo code
  //   String amount = amountField.text;
  //   dueAmount = calculateDiscountedAmount(amount, promoCodeField.text);
  //   // dueAmountField.text = dueAmount;
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // logger("service Type :: ${widget.serviceType}",
    //     loggerType: LoggerType.verbose);
    return WillPopScope(
      onWillPop: () async {
        selectedPaymentDuration.value = null;
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
              selectedPaymentDuration.value = null;
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
                  'Payment Mode',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(height: size.height * 0.02),
                Column(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: selectedPaymentDuration,
                      builder: (context, value, child) =>
                          DropdownButtonFormField<Period>(
                        value: value,
                        onChanged: (Period? val) {
                          setState(() {
                            selectedPaymentDuration.value = val;
                            paymentController.amountField.text =
                                getAmountForPeriod(val).toString();
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
                          hintText: 'No. of days',
                          hintStyle: Theme.of(context).textTheme.titleLarge,
                        ),
                        items: Period.values.map((Period period) {
                          return DropdownMenuItem<Period>(
                            value: period,
                            child: Text(
                              periodToString(period: period),
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
                SizedBox(height: size.height * 0.02),
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
                      widget.serviceType == 'offer'
                          ? getOfferAmountForPeriod(
                              selectedPaymentDuration.value)
                          : widget.serviceType == "vacancy"
                              ? getVacancyAmountForPeriod(
                                  selectedPaymentDuration.value)
                              : getMarketAmountForPeriod(
                                  selectedPaymentDuration.value),
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Obx(
                  () => paymentController.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : AppButton(
                          name: 'Submit',
                          onPressed: () {
                            var uniqueKhaltiId =
                                "${DateTime.now().millisecondsSinceEpoch}";
                            if (selectedPaymentMethod.value != null &&
                                selectedPaymentDuration.value != null) {
                              paymentController
                                  .uploadPaymentInitiate(
                                      serviceType: widget.serviceType)
                                  .then((value) {
                                if (value != null) {
                                  consolelog("value :: $value");
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
                                            "Smart Sewa Extra Services",
                                      ),
                                      preferences: [
                                        PaymentPreference.khalti,
                                      ],
                                      onSuccess: (su) {
                                        //after payment is successful then call final api after then go to...
                                        paymentController
                                            .uploadPayment(
                                                serviceType: widget.serviceType)
                                            .then((value) {
                                          consolelog("data :: $value");
                                          if (value == true) {
                                            selectedPaymentDuration.value =
                                                null;
                                            selectedPaymentMethod.value = null;
                                            if (widget.serviceType == 'offer') {
                                              offerController.uploadOffers(
                                                citizenshipFront:
                                                    widget.pickedImage,
                                                isFromServiceScreen:
                                                    widget.isFromServiceScreen,
                                              );
                                            } else if (widget.serviceType ==
                                                'vacancy') {
                                              vacancyController.uploadVacancies(
                                                file: widget.pickedImage,
                                                isFromServiceScreen:
                                                    widget.isFromServiceScreen,
                                              );
                                            } else {
                                              marketController
                                                  .uploadMarketPlace(
                                                file: widget.pickedImage,
                                                isFromServiceScreen:
                                                    widget.isFromServiceScreen,
                                              );
                                            }
                                          }
                                        }).catchError((err) {
                                          Get.back();
                                          errorToast(
                                              msg:
                                                  "Error in uploading payment data");
                                        });
                                      },
                                      onFailure: (fa) {
                                        errorToast(msg: 'Payment Failed');
                                      },
                                      onCancel: () {
                                        errorToast(msg: 'Payment Cancelled');
                                      },
                                    );
                                  } else if (selectedPaymentMethod.value ==
                                      PaymentMethod.esewa) {
                                    // Get.to(() => const EsewaPaymentScreen());
                                    //   try {
                                    //     EsewaFlutterSdk.initPayment(
                                    //       esewaConfig: EsewaConfig(
                                    //         environment: Environment.live,
                                    //         clientId:
                                    //             "${dotenv.env["ESEWA_CLIENT_ID"]}",
                                    //         secretId:
                                    //             "${dotenv.env["ESEWA_SECRET_KEY"]}",
                                    //       ),
                                    //       esewaPayment: EsewaPayment(
                                    //         productId: "smartsewa",
                                    //         productName: "Extra Services",
                                    //         productPrice: "10",
                                    //       ),
                                    //       onPaymentSuccess:
                                    //           (EsewaPaymentSuccessResult data) {
                                    //         debugPrint(":::SUCCESS::: => $data");
                                    //         paymentController
                                    //             .uploadPayment(
                                    //                 serviceType:
                                    //                     widget.serviceType)
                                    //             .then((value) {
                                    //           if (value == true) {
                                    //             selectedPaymentDuration.value =
                                    //                 null;
                                    //             selectedPaymentMethod.value =
                                    //                 null;
                                    //             if (widget.serviceType ==
                                    //                 'offer') {
                                    //               offerController.uploadOffers(
                                    //                 citizenshipFront:
                                    //                     widget.pickedImage,
                                    //                 isFromServiceScreen: widget
                                    //                     .isFromServiceScreen,
                                    //               );
                                    //             } else if (widget.serviceType ==
                                    //                 'vacancy') {
                                    //               vacancyController
                                    //                   .uploadVacancies(
                                    //                 file: widget.pickedImage,
                                    //                 isFromServiceScreen: widget
                                    //                     .isFromServiceScreen,
                                    //               );
                                    //             } else {
                                    //               marketController
                                    //                   .uploadMarketPlace(
                                    //                 file: widget.pickedImage,
                                    //                 isFromServiceScreen: widget
                                    //                     .isFromServiceScreen,
                                    //               );
                                    //             }
                                    //           }
                                    //         }).catchError((err) {
                                    //           // back(context);
                                    //           consolelog(err.toString());
                                    //           errorToast(
                                    //               msg:
                                    //                   "Error in uploading payment data");
                                    //         });
                                    //       },
                                    //       onPaymentFailure: (data) {
                                    //         debugPrint(":::FAILURE::: => $data");
                                    //         errorToast(msg: "${data.message}");
                                    //       },
                                    //       onPaymentCancellation: (data) {
                                    //         debugPrint(
                                    //             ":::CANCELLATION::: => $data");
                                    //         errorToast(msg: "${data.message}");
                                    //       },
                                    //     );
                                    // } on Exception catch (e) {
                                    //   debugPrint("EXCEPTION : ${e.toString()}");
                                    // }
                                  }
                                }
                              });
                            }

                            // submit();
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
