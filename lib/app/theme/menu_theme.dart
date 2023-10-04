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
      elevation: MaterialStatePropertyAll<double>(template.menu.elevation),
      shadowColor: MaterialStatePropertyAll<Color>(
        colors.tertararyBackground.withOpacity(0.3),
      ),
      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.fromLTRB(
          template.menu.paddingLeft,
          template.menu.paddingTop,
          template.menu.paddingRight,
          template.menu.paddingBottom,
        ),
      ),
      shape: MaterialStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(template.menu.borderRadius)),
        ),
      ),
      backgroundColor:
          MaterialStatePropertyAll<Color>(colors.secondaryBackground),
    ),
  );
}
