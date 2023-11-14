import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_text_themes.dart';

IconButtonThemeData buildIconButtonTheme(
  Template template,
  AppTextThemesExtension textThemes,
) {
  return IconButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all<Size>(
        Size(template.iconButton.width, template.iconButton.height),
      ),
    ),
  );
}
