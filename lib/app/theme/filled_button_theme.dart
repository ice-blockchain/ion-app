import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';

FilledButtonThemeData buildFilledButtonTheme(
  Template template,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return FilledButtonThemeData(
    style: ButtonStyle(
      iconSize:
          MaterialStatePropertyAll<double>(template.filledButton.iconSize),
      minimumSize: MaterialStatePropertyAll<Size>(
        Size(100, template.filledButton.minHeight),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.only(
          top: template.filledButton.paddingTop,
          bottom: template.filledButton.paddingBottom,
        ),
      ),
      textStyle: MaterialStatePropertyAll<TextStyle>(textThemes.body),
    ),
  );
}
