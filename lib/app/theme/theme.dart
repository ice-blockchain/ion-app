import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_bar_theme.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';
import 'package:ice/app/theme/icon_button_theme.dart';
import 'package:ice/app/theme/icon_theme.dart';
import 'package:ice/app/theme/menu_button_theme.dart';
import 'package:ice/app/theme/menu_theme.dart';
import 'package:ice/app/theme/text_button_theme.dart';

ThemeData buildLightTheme(TemplateTheme templateTheme) {
  final AppColorsExtension colors =
      AppColorsExtension.fromTemplate(templateTheme.colors.light);
  final AppTextThemesExtension textThemes =
      AppTextThemesExtension.fromTemplate(templateTheme.textThemes);
  return ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[colors, textThemes],
    appBarTheme: buildLightAppBarTheme(templateTheme, colors, textThemes),
    menuTheme: buildMenuTheme(templateTheme, colors, textThemes),
    menuButtonTheme: buildMenuButtonTheme(templateTheme, colors, textThemes),
    iconButtonTheme: buildIconButtonTheme(templateTheme, textThemes),
    iconTheme: buildIconTheme(templateTheme),
    textButtonTheme: buildTextButtonTheme(),
    scaffoldBackgroundColor: colors.secondaryBackground,
  );
}

ThemeData buildDarkTheme(TemplateTheme templateTheme) {
  final AppColorsExtension colors =
      AppColorsExtension.fromTemplate(templateTheme.colors.dark);
  final AppTextThemesExtension textThemes =
      AppTextThemesExtension.fromTemplate(templateTheme.textThemes);
  return ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[colors, textThemes],
    appBarTheme: buildDarkAppBarTheme(templateTheme, colors, textThemes),
    menuTheme: buildMenuTheme(templateTheme, colors, textThemes),
    menuButtonTheme: buildMenuButtonTheme(templateTheme, colors, textThemes),
    iconButtonTheme: buildIconButtonTheme(templateTheme, textThemes),
    iconTheme: buildIconTheme(templateTheme),
    textButtonTheme: buildTextButtonTheme(),
    scaffoldBackgroundColor: colors.secondaryBackground,
  );
}
