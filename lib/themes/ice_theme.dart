import 'package:flutter/material.dart';
import 'package:ice/themes/ice_colors.dart';

ThemeData get iceThemeData {
  return ThemeData(
    primaryColor: IceColors.primaryColor,
    hintColor: IceColors.hintColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: IceColors.primaryColor,
      unselectedItemColor: IceColors.hintColor,
    ),
  );
}
