// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

OutlinedButtonThemeData buildOutlinedButtonTheme() {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
      overlayColor: Colors.transparent,
    ),
  );
}
