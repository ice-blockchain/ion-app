// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/placeholder/ion_placeholder.dart';

class IonNetworkImage extends CachedNetworkImage {
  IonNetworkImage({
    required super.imageUrl,
    super.key,
    super.imageBuilder,
    super.placeholder,
    super.progressIndicatorBuilder,
    super.fadeOutDuration,
    super.fadeInDuration = Duration.zero,
    super.placeholderFadeInDuration,
    super.width,
    super.height,
    super.fit,
    super.alignment,
    super.filterQuality,
    super.cacheManager,
    Widget Function(BuildContext, String, Object)? errorWidget,
  }) : super(
          // Do not log image loading errors
          errorListener: (_) {},
          // Default error widget
          errorWidget: errorWidget ?? (context, url, error) => const IonPlaceholder(),
        );
}
