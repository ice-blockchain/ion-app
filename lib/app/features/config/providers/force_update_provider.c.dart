// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ion/app/features/config/providers/config_provider.c.dart';
import 'package:ion/app/features/config/providers/force_update_last_sync_date_provider.c.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'force_update_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ForceUpdate extends _$ForceUpdate {
  static const int eightHoursInMilliseconds = 8 * 60 * 60 * 1000;

  @override
  FutureOr<void> build() {
    ref.listen<AppLifecycleState>(
      appLifecycleProvider,
      (previous, next) {
        if (next == AppLifecycleState.resumed) {
          _checkAndUpdateConfig();
        }
      },
    );
  }

  Future<void> _checkAndUpdateConfig() async {
    final lastSyncDate = ref.read(forceUpdateLastSyncDateNotifierProvider);

    if (lastSyncDate == null ||
        DateTime.now().difference(lastSyncDate).inMilliseconds >= eightHoursInMilliseconds) {
      await ref.read(configNotifierProvider.notifier).fetchConfigForCurrentPlatform();
      ref.read(forceUpdateLastSyncDateNotifierProvider.notifier).updateLastSyncDate(DateTime.now());
    }
  }
}
