// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lifecycle_provider.c.g.dart';

@Riverpod(keepAlive: true)
class AppLifecycle extends _$AppLifecycle {
  @override
  AppLifecycleState build() {
    return AppLifecycleState.resumed;
  }

  set newState(AppLifecycleState newState) {
    state = newState;
  }
}
