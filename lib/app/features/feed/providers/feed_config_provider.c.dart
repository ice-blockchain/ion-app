// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/providers/config_repository.c.dart';
import 'package:ion/app/features/feed/data/models/feed_config.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_config_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<FeedConfig> feedConfig(Ref ref) async {
  final repository = await ref.watch(configRepositoryProvider.future);
  final result = await repository.getConfig<FeedConfig>(
    'apps-runtime_ion-app',
    cacheStrategy: AppConfigCacheStrategy.file,
    parser: (data) => FeedConfig.fromJson(jsonDecode(data) as Map<String, dynamic>),
    checkVersion: true,
  );
  return result;
}
