// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

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
