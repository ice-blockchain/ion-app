// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/theme/app_colors.dart';

TextSelectionThemeData buildTextSelectionTheme(AppColorsExtension colors) {
  return TextSelectionThemeData(
    selectionColor: colors.primaryAccent.withValues(alpha: 0.2),
    cursorColor: colors.primaryAccent,
    selectionHandleColor: colors.primaryAccent,
  );
}
