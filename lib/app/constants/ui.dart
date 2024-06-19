import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';

class UiConstants {
  UiConstants._();

  static double get hitSlop => 8.0.s;
}

class UiPadding {
  UiPadding._();

  static EdgeInsetsGeometry verticalPadding8 =
      EdgeInsets.symmetric(vertical: 8.0.s);
  static EdgeInsetsGeometry horizontalPadding16 =
      EdgeInsets.symmetric(horizontal: 16.0.s);
  static SizedBox sizedBoxHeight16 = SizedBox(height: 16.0.s);
}
