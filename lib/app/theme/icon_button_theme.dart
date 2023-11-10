import 'package:flutter/material.dart';
import 'package:ice/app/extensions/color.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_text_themes.dart';

IconButtonThemeData buildIconButtonTheme(
  Template template,
  AppTextThemesExtension textThemes,
) {
  return IconButtonThemeData(
    style: ButtonStyle(
      fixedSize: MaterialStateProperty.all<Size>(
        Size(template.iconButton.width, template.iconButton.height),
      ),
      iconSize: MaterialStateProperty.all<double>(
        template.iconButton.width,
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        HexColor(template.iconButton.backgroundColor),
      ),
    ),
  );
}
