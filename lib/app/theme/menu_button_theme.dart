import 'package:flutter/material.dart';
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
      iconSize: MaterialStatePropertyAll<double>( templateTheme.menuButton.iconSize),
      minimumSize: MaterialStatePropertyAll<Size>(
        Size(100,  templateTheme.menuButton.minHeight),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.fromLTRB(
           templateTheme.menuButton.paddingLeft,
           templateTheme.menuButton.paddingTop,
           templateTheme.menuButton.paddingRight,
           templateTheme.menuButton.paddingBottom,
        ),
      ),
      textStyle: MaterialStatePropertyAll<TextStyle>(textThemes.subtitle2),
    ),
  );
}
