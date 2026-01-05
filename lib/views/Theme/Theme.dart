import 'package:flutter/material.dart';
import 'package:smartsewa/utils/get_swatch_color.dart';

class MyTheme {
  appTheme() {
    return ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          displayMedium: TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF889AAD),
          ),
        ),
        // primarySwatch: getSwatchColor(const Color(0xFF86E91A)),
        colorScheme: ColorScheme.fromSeed(
          seedColor: MaterialColor(
              0xFF86E91A, getSwatchColor(const Color(0xFF86E91A))),
          primary: const Color(0xFF86E91A),
          secondary: const Color(0xFF86E91A),
          background: Colors.white,
          error: Colors.red,
        ),
        primaryColor: const Color(0xFF86E91A),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF5148DF),
          ),
        ),
        scaffoldBackgroundColor: Colors.black);
  }
}
