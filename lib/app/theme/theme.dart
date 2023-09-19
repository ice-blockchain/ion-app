import 'package:flutter/material.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/app_bar_theme.dart';
import 'package:ice/app/theme/app_colors.dart';
import 'package:ice/app/theme/app_text_themes.dart';

ThemeData buildLightTheme(Template template) {
  return ThemeData.light().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      AppColorsExtension.fromTemplate(template.colors.light),
      AppTextThemesExtension.fromTemplate(template.textThemes),
    ],
    appBarTheme: buildLightAppBarTheme(template),
  );
}

ThemeData buildDarkTheme(Template template) {
  return ThemeData.dark().copyWith(
    extensions: <ThemeExtension<dynamic>>[
      AppColorsExtension.fromTemplate(template.colors.dark),
      AppTextThemesExtension.fromTemplate(template.textThemes),
    ],
    appBarTheme: buildDarkAppBarTheme(template),
  );
}

extension ThemeGetter on BuildContext {
  /// Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}
