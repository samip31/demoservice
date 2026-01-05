import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../payment.dart';

ValueNotifier<LatLng?> selectedLatLng = ValueNotifier<LatLng?>(null);

ValueNotifier<String?> selectedVacancyTemplate = ValueNotifier<String?>(null);

ValueNotifier<String?> selectedItemConditionMarketPlace =
    ValueNotifier<String?>(null);
ValueNotifier<String?> selectedNegotiableMarketPlace =
    ValueNotifier<String?>(null);
ValueNotifier<String?> selectedDeliveryMarketPlace =
    ValueNotifier<String?>(null);
ValueNotifier<String?> selectedWarrantyMarketPlace =
    ValueNotifier<String?>(null);
ValueNotifier<String?> selectedSoldMarketPlace = ValueNotifier<String?>(null);

ValueNotifier<String?> selectedFilterSearchValue =
    ValueNotifier<String?>("Title");

ValueNotifier<String?> selectedVacancyStatus = ValueNotifier<String?>(null);

ValueNotifier<Period?> selectedPaymentDuration = ValueNotifier<Period?>(null);
ValueNotifier<PeriodData?> selectedPaymentDurationService =
    ValueNotifier<PeriodData?>(null);
ValueNotifier<PaymentMethod?> selectedPaymentMethod =
    ValueNotifier<PaymentMethod?>(null);

ValueNotifier<File?> selectedOfferImage = ValueNotifier<File?>(null);

ValueNotifier<bool?> selectedAutoLogin = ValueNotifier<bool?>(true);

ValueNotifier<int> serviceMainCurrentIndex = ValueNotifier<int>(0);

// const String kEsewaClientId =
//     'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R';
// const String kEsewaSecretKey = 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==';
