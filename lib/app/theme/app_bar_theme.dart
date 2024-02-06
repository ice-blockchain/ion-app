import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';

AppBarTheme _buildBaseAppBarTheme(
  Template template,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return const AppBarTheme().copyWith(
    toolbarHeight: template.appBar.toolbarHeight,
    backgroundColor: colors.primaryBackground,
    titleTextStyle: textThemes.caption2.copyWith(color: colors.attentionRed),
    iconTheme: IconThemeData(color: colors.attentionRed),
  );
}

AppBarTheme buildLightAppBarTheme(
  Template template,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return _buildBaseAppBarTheme(template, colors, textThemes).copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}

AppBarTheme buildDarkAppBarTheme(
  Template template,
  AppColorsExtension colors,
  AppTextThemesExtension textThemes,
) {
  return _buildBaseAppBarTheme(template, colors, textThemes).copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}
