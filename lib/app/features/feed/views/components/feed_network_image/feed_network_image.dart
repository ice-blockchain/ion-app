// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/components/image/ion_network_image.dart';
import 'package:ion/app/features/components/ion_connect_network_image/ion_connect_network_image.dart';
import 'package:ion/app/features/feed/providers/feed_images_cache_manager.dart';

class FeedNetworkImage extends IonNetworkImage {
  FeedNetworkImage({
    required super.imageUrl,
    super.key,
    super.imageBuilder,
    super.progressIndicatorBuilder,
    super.fadeOutDuration = Duration.zero,
    super.fadeInDuration = Duration.zero,
    super.placeholderFadeInDuration = Duration.zero,
    super.width,
    super.height,
    super.fit,
    super.alignment,
    super.filterQuality,
    super.placeholder,
  }) : super(
          cacheManager: FeedImagesCacheManager.instance,
        );
}

class FeedIONConnectNetworkImage extends IonConnectNetworkImage {
  FeedIONConnectNetworkImage({
    required super.imageUrl,
    required super.authorPubkey,
    super.imageBuilder,
    super.progressIndicatorBuilder,
    super.width,
    super.height,
    super.alignment,
    super.filterQuality,
    super.fit,
    super.errorWidget,
    super.placeholder,
    super.key,
  }) : super(
          cacheManager: FeedImagesCacheManager.instance,
        );
}
