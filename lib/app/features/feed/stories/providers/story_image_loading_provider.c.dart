// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_image_loading_provider.c.g.dart';

const _kStoryCacheKey = 'story_image_cache';

/// A provider to track loading states for story images
@riverpod
class StoryImagesLoadStatusController extends _$StoryImagesLoadStatusController {
  @override
  Map<String, bool> build() => <String, bool>{};

  void markLoaded(String storyId) {
    state = {
      ...state,
      storyId: true,
    };
  }

  bool isLoaded(String storyId) => state[storyId] ?? false;
}

@Riverpod(keepAlive: true)
BaseCacheManager storyImageCacheManager(Ref ref) {
  final expirationHours =
      ref.read(envProvider.notifier).get<int>(EnvVariable.STORY_EXPIRATION_HOURS);

  return CacheManager(
    Config(
      _kStoryCacheKey,
      stalePeriod: Duration(hours: expirationHours),
      maxNrOfCacheObjects: 100,
    ),
  );
}
