import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';

MenuButtonThemeData buildMenuButtonTheme(
  TemplateTheme templateTheme,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return MenuButtonThemeData(
    style: ButtonStyle(
      minimumSize: MaterialStatePropertyAll<Size>(
        Size(100.0.s, templateTheme.menuButton.minHeight.s),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.fromLTRB(
          templateTheme.menuButton.paddingLeft.s,
          templateTheme.menuButton.paddingTop.s,
          templateTheme.menuButton.paddingRight.s,
          templateTheme.menuButton.paddingBottom.s,
        ),
      ),
      textStyle: MaterialStatePropertyAll<TextStyle>(textThemes.subtitle2),
    ),
  );
}
