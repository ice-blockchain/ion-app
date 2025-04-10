// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ion/app/features/core/providers/app_info_provider.c.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.c.dart';
import 'package:ion/app/features/force_update/providers/min_app_version_repository.c.dart';
import 'package:ion/app/utils/version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'force_update_provider.c.g.dart';

@Riverpod(keepAlive: true)
class ForceUpdate extends _$ForceUpdate {
  @override
  bool? build() {
    ref.listen<AppLifecycleState>(
      appLifecycleProvider,
      (previous, next) {
        if (next == AppLifecycleState.resumed) {
          _checkForceUpdateRequired();
        }
      },
      fireImmediately: true,
    );
    return null;
  }

  Future<void> _checkForceUpdateRequired() async {
    final repository = await ref.read(minAppVersionRepositoryProvider.future);
    final minVersion = await repository.getMinVersion();

    final appInfo = await ref.read(appInfoProvider.future);
    final appVersion = appInfo.version;

    final notSupported = compareVersions(appVersion, minVersion) == -1;
    state = notSupported;
  }
}
