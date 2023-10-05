import 'package:flutter/material.dart';
import 'package:ice/app/theme/app_text_themes.dart';

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appTextThemes;
  AppTextThemesExtension get appTextThemes =>
      extension<AppTextThemesExtension>()!;
}
