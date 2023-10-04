import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';

MenuThemeData buildMenuTheme(
  Template template,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return MenuThemeData(
    style: MenuStyle(
      elevation: const MaterialStatePropertyAll<double>(16),
      shadowColor: const MaterialStatePropertyAll<Color>(Colors.black38),
      padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 11),
      ),
      shape: const MaterialStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      backgroundColor:
          MaterialStatePropertyAll<Color>(colors.secondaryBackground),
    ),
  );
}
