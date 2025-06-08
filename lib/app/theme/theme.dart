// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/services/providers/templates/template.c.dart';
import 'package:ion/app/theme/app_bar_theme.dart';
import 'package:ion/app/theme/app_colors.dart';
import 'package:ion/app/theme/app_text_themes.dart';
import 'package:ion/app/theme/bottom_sheet_theme.dart';
import 'package:ion/app/theme/elevated_button_theme.dart';
import 'package:ion/app/theme/icon_button_theme.dart';
import 'package:ion/app/theme/icon_theme.dart';
import 'package:ion/app/theme/menu_button_theme.dart';
import 'package:ion/app/theme/menu_theme.dart';
import 'package:ion/app/theme/outline_button_theme.dart';
import 'package:ion/app/theme/tab_bar_theme.dart';
import 'package:ion/app/theme/text_button_theme.dart';
import 'package:ion/app/theme/text_selection_theme.dart';

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
    tabBarTheme: buildTabBarTheme(),
    textSelectionTheme: buildTextSelectionTheme(colors),

    /// Overrides the default Cupertino theme to ensure text selection handles and
    /// other Cupertino-styled widgets use our brand color on iOS/macOS.
    /// Without this, text selection handles on iOS remain the system default
    /// (purple), rather than matching the Material theme’s selection color.
    cupertinoOverrideTheme: const CupertinoThemeData().copyWith(
      primaryColor: colors.primaryAccent,
    ),
  );
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
    textSelectionTheme: buildTextSelectionTheme(colors),
    cupertinoOverrideTheme: const CupertinoThemeData().copyWith(
      primaryColor: colors.primaryAccent,
    ),
  );
}
