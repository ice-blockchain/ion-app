import 'package:flutter/material.dart';
import 'package:ice/app/theme/app_colors.dart';

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColorsExtension get appColors => extension<AppColorsExtension>()!;
}
