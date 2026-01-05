import 'package:flutter/material.dart';

class CustomText {
  static Text ourText(
    String? data, {
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign = TextAlign.start,
    double? fontSize = 16,
    int? maxLines = 2,
    bool? isMaxLine = true,
    TextDecoration? textDecoration,
    bool? isFontFamily = true,
    FontStyle? fontStyle,
  }) =>
      Text(
        data ?? '',
        textAlign: textAlign,
        maxLines: isMaxLine == true ? maxLines : null,
        overflow: isMaxLine == true ? TextOverflow.ellipsis : null,
        style: TextStyle(
          decoration: textDecoration ?? TextDecoration.none,
          fontSize: fontSize,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? Colors.white,
          fontStyle: fontStyle ?? FontStyle.normal,
        ),
      );
}
