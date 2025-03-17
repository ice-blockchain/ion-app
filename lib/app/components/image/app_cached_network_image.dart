// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';

class AppCachedNetworkImage extends CachedNetworkImage {
  AppCachedNetworkImage({
    required super.imageUrl,
    super.key,
    super.imageBuilder,
    super.placeholder,
    super.progressIndicatorBuilder,
    super.errorWidget,
    super.fadeOutDuration,
    super.fadeInDuration = Duration.zero,
    super.placeholderFadeInDuration,
    super.width,
    super.height,
    super.fit,
    super.alignment,
    super.filterQuality,
    super.cacheManager,
  });
}
