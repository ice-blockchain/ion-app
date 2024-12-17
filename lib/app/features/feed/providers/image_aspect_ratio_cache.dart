// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/media_service/aspect_ratio.dart';

final imageAspectRatioCacheProvider = Provider<ImageAspectRatioCache>((ref) {
  return ImageAspectRatioCache();
});

class ImageAspectRatioCache {
  final Map<String, Future<MediaAspectRatioResult>> _cache = {};

  Future<MediaAspectRatioResult> getAspectRatio(String url) {
    return _cache.putIfAbsent(url, () async {
      final completer = Completer<Size>();
      final image = Image.network(url);
      image.image.resolve(ImageConfiguration.empty).addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          final width = info.image.width.toDouble();
          final height = info.image.height.toDouble();
          completer.complete(Size(width, height));
        }),
      );

      final size = await completer.future;

      final aspectRatio = size.width / size.height;
      if (aspectRatio >= 1.0) {
        return MediaAspectRatioResult(aspectRatio.clamp(1.0, maxHorizontalMediaAspectRatio));
      } else {
        return MediaAspectRatioResult(aspectRatio.clamp(minVerticalMediaAspectRatio, 1.0));
      }
    });
  }
}
