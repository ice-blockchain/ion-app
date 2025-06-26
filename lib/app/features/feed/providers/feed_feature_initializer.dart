// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/feed_config_provider.r.dart';
import 'package:ion/app/features/feed/providers/feed_images_cache_manager.dart';

class FeedFeatureInitializer {
  FeedFeatureInitializer();

  Future<void> init(Ref ref) async {
    final feedConfig = await ref.read(feedConfigProvider.future);

    FeedImagesCacheManager.init(
      maxConcurrentDownloads: feedConfig.concurrentMediaDownloadsLimit,
    );
  }
}
