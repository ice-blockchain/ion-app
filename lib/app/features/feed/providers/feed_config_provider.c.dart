// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/feed_config.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_config_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<FeedConfig> feedConfig(Ref ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 500));
  return FeedConfig.fromJson({
    'interestedThreshold': 0.5,
    'notInterestedCategoryChance': 0.3,
    'notInterestedSubcategoryChance': 0.2,
    'concurrentRequests': 3,
    'followingReqMaxAge': const Duration(days: 4).inMilliseconds,
    'followingCacheMaxAge': const Duration(days: 7).inMilliseconds,
    'topMaxAge': const Duration(days: 3).inMilliseconds,
    'trendingMaxAge': const Duration(days: 1).inMilliseconds,
    'exploreMaxAge': const Duration(hours: 12).inMilliseconds,
    'repostThrottleDelay': const Duration(hours: 3).inMilliseconds,
  });

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
