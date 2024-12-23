// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/config/providers/config_provider.c.dart';
import 'package:ion/app/features/config/providers/force_update_last_sync_date_provider.c.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/force_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'force_update_provider.c.freezed.dart';
part 'force_update_provider.c.g.dart';

@freezed
class ForceUpdateState with _$ForceUpdateState {
  const factory ForceUpdateState({
    @Default(false) bool showUpdateModal,
  }) = _ForceUpdateState;

  const ForceUpdateState._();
}

@Riverpod(keepAlive: true)
class ForceUpdate extends _$ForceUpdate {
  static const int eightHoursInMilliseconds = 8 * 60 * 60 * 1000;

  @override
  ForceUpdateState build() {
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

    Logger.log('lastSyncDate: $lastSyncDate');

    if (lastSyncDate == null ||
        DateTime.now().difference(lastSyncDate).inMilliseconds >= eightHoursInMilliseconds) {
      final remoteVersion =
          await ref.read(configNotifierProvider.notifier).fetchConfigForCurrentPlatform();

      final packageInfo = await PackageInfo.fromPlatform();
      final localVersion = packageInfo.version;

      if (ForceUpdateUtil.isVersionOutdated(localVersion, remoteVersion)) {
        state = state.copyWith(showUpdateModal: true);
      } else {
        state = state.copyWith(showUpdateModal: false);
      }

      ref.read(forceUpdateLastSyncDateNotifierProvider.notifier).updateLastSyncDate(DateTime.now());
    }
  }

  void resetUpdateModal() {
    state = state.copyWith(showUpdateModal: false);
  }
}
