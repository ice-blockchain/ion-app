// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/theme/app_colors.dart';

BottomSheetThemeData buildBottomSheetTheme(
  AppColorsExtension colors,
) {
  return BottomSheetThemeData(
    modalBarrierColor: colors.backgroundSheet,
  );
}
