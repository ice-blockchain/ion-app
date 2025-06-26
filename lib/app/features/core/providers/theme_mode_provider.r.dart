// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.r.g.dart';

@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() {
    return ThemeMode.light;
  }

  set themeMode(ThemeMode themeMode) {
    state = themeMode;
  }
}
