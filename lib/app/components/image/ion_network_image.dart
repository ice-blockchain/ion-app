// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/placeholder/ion_placeholder.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class IonNetworkImage extends StatelessWidget {
  const IonNetworkImage({
    required this.imageUrl,
    super.key,
    this.imageBuilder,
    this.progressIndicatorBuilder,
    this.fadeOutDuration = Duration.zero,
    this.fadeInDuration = Duration.zero,
    this.placeholderFadeInDuration = Duration.zero,
    this.width,
    this.height,
    this.fit,
    this.alignment,
    this.filterQuality,
    this.cacheManager,
    this.placeholder,
    this.errorListener,
    this.errorWidget,
  });

  final String imageUrl;
  final Widget Function(BuildContext, String, Object)? errorWidget;
  final ValueChanged<Object>? errorListener;
  final Widget? placeholder;
  final Duration fadeOutDuration;
  final Duration fadeInDuration;
  final Duration placeholderFadeInDuration;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment? alignment;
  final FilterQuality? filterQuality;
  final CacheManager? cacheManager;
  final ImageWidgetBuilder? imageBuilder;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => placeholder ?? const IonPlaceholder(),
      errorListener: errorListener ?? (_) {},
      errorWidget: errorWidget ?? (context, url, error) => const IonPlaceholder(),
      fadeOutDuration: fadeOutDuration,
      fadeInDuration: fadeInDuration,
      placeholderFadeInDuration: placeholderFadeInDuration,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      filterQuality: filterQuality ?? FilterQuality.medium,
      cacheManager: cacheManager,
      imageBuilder: imageBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      memCacheWidth: width != null ? (width! * MediaQuery.of(context).devicePixelRatio).toInt().clamp(0, 1920) : null,
      memCacheHeight: height != null ? (height! * MediaQuery.of(context).devicePixelRatio).toInt().clamp(0, 1080) : null,
    );
  }
}
