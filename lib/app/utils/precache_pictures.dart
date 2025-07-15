// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/image_path.dart';

Future<void> precachePictures(Iterable<String> urls) async {
  try {
    await Future.wait(urls.map(_precachePicture));
  } catch (e) {
    Logger.error(e, stackTrace: StackTrace.current, message: 'Failed to precache pictures: $urls');
  }
}

Future<void> _precachePicture(String url) async {
  if (url.isSvg) {
    final loader = url.isNetworkSvg ? SvgNetworkLoader(url) : SvgAssetLoader(url);

    await svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
  } else {
    await DefaultCacheManager().downloadFile(url);
  }
}
