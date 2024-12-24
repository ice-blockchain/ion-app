// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/config/providers/config_provider.c.dart';
import 'package:ion/app/features/config/providers/force_update_last_sync_date_provider.c.dart';
import 'package:ion/app/features/config/providers/force_update_util_provider.c.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'force_update_provider.c.freezed.dart';
part 'force_update_provider.c.g.dart';

@freezed
class ForceUpdateState with _$ForceUpdateState {
  const factory ForceUpdateState({
    @Default(false) bool shouldShowUpdateModal,
  }) = _ForceUpdateState;

  const ForceUpdateState._();
}

@Riverpod(keepAlive: true)
class ForceUpdate extends _$ForceUpdate {
  static const int eightHoursInMilliseconds = 8 * 60 * 60 * 1000;

  @override
  ForceUpdateState build() {
    _checkAndUpdateConfig();

    ref.listen<AppLifecycleState>(
      appLifecycleProvider,
      (previous, next) {
        if (next == AppLifecycleState.resumed) {
          _checkAndUpdateConfig();
        }
      },
    );

    return const ForceUpdateState();
  }

  Future<void> _checkAndUpdateConfig() async {
    final lastSyncDate = ref.read(forceUpdateLastSyncDateNotifierProvider);

    if (lastSyncDate == null ||
        DateTime.now().difference(lastSyncDate).inMilliseconds >= eightHoursInMilliseconds) {
      final remoteVersion = await ref.read(configForPlatformProvider.future);

      final packageInfo = await PackageInfo.fromPlatform();
      final localVersion = packageInfo.version;

      if (localVersion == remoteVersion) {
        state = state.copyWith(shouldShowUpdateModal: false);

        ref
            .read(forceUpdateLastSyncDateNotifierProvider.notifier)
            .updateLastSyncDate(DateTime.now());
      } else if (ref
          .read(forceUpdateServiceProvider)
          .isVersionOutdated(localVersion, remoteVersion)) {
        state = state.copyWith(shouldShowUpdateModal: true);
      }
    }
  }
}
