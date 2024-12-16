// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/theme/app_colors.dart';
import 'package:ion/app/theme/app_text_themes.dart';

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppColorsExtension.defaultColors();

  /// Usage example: Theme.of(context).appTextThemes;
  AppTextThemesExtension get appTextThemes =>
      extension<AppTextThemesExtension>() ?? AppTextThemesExtension.defaultTextThemes();
}
