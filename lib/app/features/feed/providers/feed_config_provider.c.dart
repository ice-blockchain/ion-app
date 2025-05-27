// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/config/data/models/app_config_cache_strategy.dart';
import 'package:ion/app/features/config/providers/config_repository.c.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:ion/app/features/feed/data/models/feed_config.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_config_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<FeedConfig> feedConfig(Ref ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 500));
  return const FeedConfig(
    notInterestedThreshold: 0.5,
    notInterestedCategoryChance: 0.3,
    notInterestedSubcategoryChance: 0.2,
    followingMaxAge: Duration(days: 7),
    topMaxAge: Duration(days: 3),
    trendingMaxAge: Duration(days: 1),
    exploreMaxAge: Duration(hours: 12),
  );

  // final env = ref.read(envProvider.notifier);
  // final cacheDuration = env.get<Duration>(EnvVariable.GENERIC_CONFIG_CACHE_DURATION);
  // final repository = await ref.watch(configRepositoryProvider.future);
  // final result = await repository.getConfig<FeedConfig>(
  //   'TODO', //TODO: set url
  //   cacheStrategy: AppConfigCacheStrategy.file,
  //   refreshInterval: cacheDuration.inMilliseconds,
  //   parser: (data) => FeedConfig.fromJson(jsonDecode(data) as Map<String, dynamic>),
  //   checkVersion: true,
  // );
  // return result;
}
