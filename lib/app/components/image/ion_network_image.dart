// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';

class IonNetworkImage extends CachedNetworkImage {
  IonNetworkImage({
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
  }) :
        // Do not log image loading errors
        super(errorListener: (_) {});
}
