import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';

MenuButtonThemeData buildMenuButtonTheme(
  Template template,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return MenuButtonThemeData(
    style: ButtonStyle(
      iconSize: const MaterialStatePropertyAll<double>(28),
      minimumSize: const MaterialStatePropertyAll<Size>(Size(100, 46)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.fromLTRB(16, 0, 13, 0),
      ),
      textStyle: MaterialStatePropertyAll<TextStyle>(textThemes.subtitle2),
    ),
  );
}
