// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:window_manager/window_manager.dart' as wm;

part 'window_manager_provider.r.g.dart';

@Riverpod(keepAlive: true)
class WindowManager extends _$WindowManager {
  @override
  wm.WindowManager? build() {
    final isAvailable = !kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows);
    return isAvailable ? wm.windowManager : null;
  }

  Future<void> show() async {
    final manager = state;
    if (manager != null) {
      await manager.ensureInitialized();

      const options = wm.WindowOptions(
        size: Size(375, 812),
        center: true,
        windowButtonVisibility: true,
        titleBarStyle: wm.TitleBarStyle.normal,
        title: 'Ice Open Network',
      );

      await manager.waitUntilReadyToShow(options);
      await manager.setResizable(false);
      await manager.show();
      await manager.focus();
    }
  }
}
