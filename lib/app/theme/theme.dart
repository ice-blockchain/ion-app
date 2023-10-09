import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_bar_theme.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';
import 'package:ice/app/theme/filled_button_theme.dart';
import 'package:ice/app/theme/menu_button_theme.dart';
import 'package:ice/app/theme/menu_theme.dart';

ThemeData buildLightTheme(Template template) {
  final AppColorsExtension colors =
      AppColorsExtension.fromTemplate(template.colors.light);
  final AppTextThemesExtension textThemes =
      AppTextThemesExtension.fromTemplate(template.textThemes);
  return ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[colors, textThemes],
    appBarTheme: buildLightAppBarTheme(template, colors, textThemes),
    menuTheme: buildMenuTheme(template, colors, textThemes),
    menuButtonTheme: buildMenuButtonTheme(template, colors, textThemes),
    filledButtonTheme: buildFilledButtonTheme(template, colors, textThemes),
  );
}

ThemeData buildDarkTheme(Template template) {
  final AppColorsExtension colors =
      AppColorsExtension.fromTemplate(template.colors.dark);
  final AppTextThemesExtension textThemes =
      AppTextThemesExtension.fromTemplate(template.textThemes);
  return ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[colors, textThemes],
    appBarTheme: buildDarkAppBarTheme(template, colors, textThemes),
    menuTheme: buildMenuTheme(template, colors, textThemes),
    menuButtonTheme: buildMenuButtonTheme(template, colors, textThemes),
  );
}
