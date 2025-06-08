// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/services/providers/templates/template.c.dart';
import 'package:ion/app/theme/app_colors.dart';
import 'package:ion/app/theme/app_text_themes.dart';

AppBarTheme _buildBaseAppBarTheme(
  TemplateTheme templateTheme,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return const AppBarTheme().copyWith(
    toolbarHeight: templateTheme.appBar.toolbarHeight.s,
    backgroundColor: colors.primaryBackground,
    titleTextStyle: textThemes.caption2.copyWith(color: colors.attentionRed),
    iconTheme: IconThemeData(color: colors.attentionRed),
  );
}

AppBarTheme buildLightAppBarTheme(
  TemplateTheme templateTheme,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return _buildBaseAppBarTheme(templateTheme, colors, textThemes).copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}

AppBarTheme buildDarkAppBarTheme(
  TemplateTheme templateTheme,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return _buildBaseAppBarTheme(templateTheme, colors, textThemes).copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}
