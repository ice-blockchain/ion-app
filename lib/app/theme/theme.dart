import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_bar_theme.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';
import 'package:ice/app/theme/bottom_sheet_theme.dart';
import 'package:ice/app/theme/elevated_button_theme.dart';
import 'package:ice/app/theme/icon_button_theme.dart';
import 'package:ice/app/theme/icon_theme.dart';
import 'package:ice/app/theme/menu_button_theme.dart';
import 'package:ice/app/theme/menu_theme.dart';
import 'package:ice/app/theme/outline_button_theme.dart';
import 'package:ice/app/theme/tab_bar_theme.dart';
import 'package:ice/app/theme/text_button_theme.dart';

ThemeData buildLightTheme(TemplateTheme templateTheme) {
  final colors = AppColorsExtension.fromTemplate(templateTheme.colors.light);
  final textThemes = AppTextThemesExtension.fromTemplate(templateTheme.textThemes);
  return ThemeData.light().copyWith(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      extensions: <ThemeExtension<dynamic>>[colors, textThemes],
      appBarTheme: buildLightAppBarTheme(templateTheme, colors, textThemes),
      menuTheme: buildMenuTheme(templateTheme, colors, textThemes),
      menuButtonTheme: buildMenuButtonTheme(templateTheme, colors, textThemes),
      iconButtonTheme: buildIconButtonTheme(templateTheme, textThemes),
      elevatedButtonTheme: buildElevatedButtonTheme(),
      outlinedButtonTheme: buildOutlinedButtonTheme(),
      iconTheme: buildIconTheme(templateTheme),
      textButtonTheme: buildTextButtonTheme(),
      scaffoldBackgroundColor: colors.secondaryBackground,
      bottomSheetTheme: buildBottomSheetTheme(colors),
      tabBarTheme: buildTabBarTheme());
}

ThemeData buildDarkTheme(TemplateTheme templateTheme) {
  final colors = AppColorsExtension.fromTemplate(templateTheme.colors.dark);
  final textThemes = AppTextThemesExtension.fromTemplate(templateTheme.textThemes);
  return ThemeData.dark().copyWith(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    extensions: <ThemeExtension<dynamic>>[colors, textThemes],
    appBarTheme: buildDarkAppBarTheme(templateTheme, colors, textThemes),
    menuTheme: buildMenuTheme(templateTheme, colors, textThemes),
    menuButtonTheme: buildMenuButtonTheme(templateTheme, colors, textThemes),
    iconButtonTheme: buildIconButtonTheme(templateTheme, textThemes),
    elevatedButtonTheme: buildElevatedButtonTheme(),
    outlinedButtonTheme: buildOutlinedButtonTheme(),
    iconTheme: buildIconTheme(templateTheme),
    textButtonTheme: buildTextButtonTheme(),
    scaffoldBackgroundColor: colors.secondaryBackground,
    bottomSheetTheme: buildBottomSheetTheme(colors),
    tabBarTheme: buildTabBarTheme(),
  );
}
