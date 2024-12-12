// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/theme/app_colors.dart';
import 'package:ion/app/theme/app_text_themes.dart';

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColorsExtension get appColors => extension<AppColorsExtension>()!;

  /// Usage example: Theme.of(context).appTextThemes;
  AppTextThemesExtension get appTextThemes => extension<AppTextThemesExtension>()!;

  /// Flutter returns null if extension is not initialized, so we need to check it before using it.
  bool get isInitialized =>
      extension<AppColorsExtension>() != null && extension<AppTextThemesExtension>() != null;
}
