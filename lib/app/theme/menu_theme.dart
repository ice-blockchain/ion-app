// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';

MenuThemeData buildMenuTheme(
  TemplateTheme templateTheme,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return MenuThemeData(
    style: MenuStyle(
      elevation: WidgetStatePropertyAll<double>(templateTheme.menu.elevation),
      shadowColor: WidgetStatePropertyAll<Color>(
        colors.tertararyBackground,
      ),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.fromLTRB(
          templateTheme.menu.paddingLeft.s,
          templateTheme.menu.paddingTop.s,
          templateTheme.menu.paddingRight.s,
          templateTheme.menu.paddingBottom.s,
        ),
      ),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(templateTheme.menu.borderRadius.s),
          ),
        ),
      ),
      backgroundColor: WidgetStatePropertyAll<Color>(colors.secondaryBackground),
      surfaceTintColor: WidgetStatePropertyAll<Color>(colors.secondaryBackground),
    ),
  );
}
