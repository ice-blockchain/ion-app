// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/providers/config_repository.r.dart';
import 'package:ion/app/features/core/providers/app_info_provider.r.dart';
import 'package:ion/app/features/core/providers/app_lifecycle_provider.r.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/features/force_update/model/min_app_version_config_name.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'force_update_provider.r.g.dart';

@Riverpod(keepAlive: true)
class ForceUpdate extends _$ForceUpdate {
  @override
  Future<bool> build() {
    ref.listen<AppLifecycleState>(
      appLifecycleProvider,
      (previous, next) async {
        if (next == AppLifecycleState.resumed) {
          final isForceUpdateRequired = await _checkIsForceUpdateRequired();
          if (state.valueOrNull != isForceUpdateRequired) {
            state = AsyncData(isForceUpdateRequired);
          }
        }
      },
    );
    return _checkIsForceUpdateRequired();
  }

  Future<bool> _checkIsForceUpdateRequired() async {
    try {
      final repository = await ref.read(configRepositoryProvider.future);

      final minVersion = await repository.getConfig<String>(
        MinAppVersionConfigName.fromPlatform().toString(),
        cacheStrategy: AppConfigCacheStrategy.localStorage,
        refreshInterval: ref
            .read(envProvider.notifier)
            .get<Duration>(EnvVariable.MIN_APP_VERSION_CONFIG_CACHE_DURATION),
        parser: (data) => data,
      );

      final appInfo = await ref.read(appInfoProvider.future);
      final appVersion = '${appInfo.version}.${appInfo.buildNumber}';

      return compareVersions(appVersion, minVersion) == -1;
    } catch (error, stackTrace) {
      Logger.error(
        error,
        stackTrace: stackTrace,
        message: 'Failed to check if force update is required',
      );
      return false;
    }
  }
}
