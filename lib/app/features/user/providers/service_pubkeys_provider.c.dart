// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/providers/config_repository.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_pubkeys_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> servicePubkeys(Ref ref) async {
  final env = ref.read(envProvider.notifier);
  final cacheMinutes = env.get<int>(EnvVariable.PUSH_TRANSLATIONS_CACHE_MINUTES);
  final refreshInterval = Duration(minutes: cacheMinutes).inMilliseconds;
  final repo = await ref.watch(configRepositoryProvider.future);
  final result = await repo.getConfig<List<String>>(
    'service_pubkeys',
    cacheStrategy: AppConfigCacheStrategy.localStorage,
    refreshInterval: refreshInterval,
    parser: (data) => (jsonDecode(data) as List<dynamic>).cast<String>(),
    checkVersion: true,
  );
  return result;
}
