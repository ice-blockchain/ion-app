// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/services/providers/templates/template.c.dart';
import 'package:ion/app/theme/app_colors.dart';
import 'package:ion/app/theme/app_text_themes.dart';

MenuButtonThemeData buildMenuButtonTheme(
  TemplateTheme templateTheme,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return MenuButtonThemeData(
    style: ButtonStyle(
      minimumSize: WidgetStatePropertyAll<Size>(
        Size(100.0.s, templateTheme.menuButton.minHeight.s),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsetsDirectional.fromSTEB(
          templateTheme.menuButton.paddingLeft.s,
          templateTheme.menuButton.paddingTop.s,
          templateTheme.menuButton.paddingRight.s,
          templateTheme.menuButton.paddingBottom.s,
        ),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle>(textThemes.subtitle2),
    ),
  );
}
