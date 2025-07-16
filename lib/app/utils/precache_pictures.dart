// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/image_path.dart';

Future<void> precachePictures(Iterable<String> urls) async {
  try {
    await Future.wait(urls.map(_precachePicture));
  } catch (e, stackTrace) {
    Logger.error(e, stackTrace: stackTrace, message: 'Failed to precache pictures: $urls');
  }
}

Future<void> _precachePicture(String url) async {
  if (url.isSvg) {
    final loader = url.isNetworkSvg ? SvgNetworkLoader(url) : SvgAssetLoader(url);

    await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  } else {
    // For other image types, let the cache manager handle everything.
    // .getSingleFile() will download the file if not cached, then return it.
    // We don't need the file itself, just the action of caching.
    await DefaultCacheManager().getSingleFile(url);
  }
}
