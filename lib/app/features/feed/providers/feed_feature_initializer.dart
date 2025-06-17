// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/feed/providers/feed_feature_flags_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_images_cache_manager.c.dart';

class FeedFeatureInitializer {
  FeedFeatureInitializer();

  Future<void> init(Ref ref) async {
    FeedImagesCacheManager.init(
      maxConcurrentDownloads:
          ref.read(feedFeatureFlagsProvider.notifier).get(FeedFeatureFlag.concurrentDownloadLimit),
    );
  }
}
