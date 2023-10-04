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
      iconSize: MaterialStatePropertyAll<double>(template.menuButton.iconSize),
      minimumSize: MaterialStatePropertyAll<Size>(
        Size(100, template.menuButton.minHeight),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.fromLTRB(
          template.menuButton.paddingLeft,
          template.menuButton.paddingTop,
          template.menuButton.paddingRight,
          template.menuButton.paddingBottom,
        ),
      ),
      textStyle: MaterialStatePropertyAll<TextStyle>(textThemes.subtitle2),
    ),
  );
}
