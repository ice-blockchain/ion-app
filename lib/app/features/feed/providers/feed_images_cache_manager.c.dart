// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:ion/app/services/file_cache/limited_concurrent_http_file_service.dart';

class FeedImagesCacheManager {
  static late final CacheManager instance;

  static const key = 'feedImagesCacheKey';

  static void init({required int maxConcurrentDownloads}) {
    final config = Config(
      key,
      fileService: LimitedConcurrentHttpFileService(concurrentFetches: maxConcurrentDownloads),
    );

    instance = CacheManager(
      config,
    );
  }
}
