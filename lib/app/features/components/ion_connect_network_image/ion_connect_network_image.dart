// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/image/ion_network_image.dart';
import 'package:ion/app/features/core/providers/ion_connect_media_url_fallback_provider.r.dart';

class IonConnectNetworkImage extends ConsumerWidget {
  const IonConnectNetworkImage({
    required this.imageUrl,
    required this.authorPubkey,
    this.imageBuilder,
    this.progressIndicatorBuilder,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.cacheManager,
    this.fit,
    this.errorWidget,
    this.placeholder,
    this.fadeInDuration,
    this.fadeOutDuration,
    super.key,
  });

  final String imageUrl;
  final String authorPubkey;
  final BaseCacheManager? cacheManager;
  final ImageWidgetBuilder? imageBuilder;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final PlaceholderWidgetBuilder? placeholder;
  final BoxFit? fit;
  final FilterQuality filterQuality;
  final Alignment alignment;
  final double? width;
  final double? height;
  final Duration? fadeInDuration;
  final Duration? fadeOutDuration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourcePath = ref
        .watch(iONConnectMediaUrlFallbackProvider.select((state) => state[imageUrl] ?? imageUrl));

    return IonNetworkImage(
      imageUrl: sourcePath,
      cacheManager: cacheManager,
      imageBuilder: imageBuilder,
      placeholder: placeholder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      fit: fit,
      filterQuality: filterQuality,
      alignment: alignment,
      width: width,
      height: height,
      fadeInDuration: fadeInDuration ?? Duration.zero,
      fadeOutDuration: fadeOutDuration ?? Duration.zero,
      errorListener: (error) {
        if (ref.context.mounted) {
          ref.read(iONConnectMediaUrlFallbackProvider.notifier).generateFallback(
                imageUrl,
                authorPubkey: authorPubkey,
              );
        }
      },
    );
  }
}
