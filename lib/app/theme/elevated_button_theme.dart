import 'package:flutter/material.dart';

ElevatedButtonThemeData buildElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
      overlayColor: Colors.transparent,
    ),
  );
}
