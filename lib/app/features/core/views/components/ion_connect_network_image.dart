import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/image/ion_network_image.dart';
import 'package:ion/app/components/placeholder/ion_placeholder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';

class IonConnectNetworkImage extends StatelessWidget {
  const IonConnectNetworkImage({
    required this.imageUrl,
    this.imageBuilder,
    this.progressIndicatorBuilder,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.cacheManager,
    this.fit,
    this.errorWidget,
    super.key,
  });

  final BaseCacheManager? cacheManager;
  final ImageWidgetBuilder? imageBuilder;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final String imageUrl;
  final BoxFit? fit;
  final FilterQuality filterQuality;
  final Alignment alignment;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return IonNetworkImage(
      imageUrl: imageUrl,
      cacheManager: cacheManager,
      imageBuilder: imageBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      fit: fit,
      filterQuality: filterQuality,
      alignment: alignment,
      width: width,
      height: height,
      errorWidget: (
        BuildContext context,
        String url,
        Object error,
      ) {
        return _IonConnectNetworkImageFallback(
          imageUrl: imageUrl,
          cacheManager: cacheManager,
          imageBuilder: imageBuilder,
          progressIndicatorBuilder: progressIndicatorBuilder,
          fit: fit,
          filterQuality: filterQuality,
          alignment: alignment,
          width: width,
          height: height,
          errorWidget: errorWidget,
        );
      },
    );
  }
}

class _IonConnectNetworkImageFallback extends HookConsumerWidget {
  const _IonConnectNetworkImageFallback({
    required this.imageUrl,
    this.imageBuilder,
    this.progressIndicatorBuilder,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.cacheManager,
    this.fit,
    this.errorWidget,
  });

  final BaseCacheManager? cacheManager;
  final ImageWidgetBuilder? imageBuilder;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final String imageUrl;
  final BoxFit? fit;
  final FilterQuality filterQuality;
  final Alignment alignment;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRelays = ref.watch(currentUserRelayProvider).valueOrNull;

    // Trying to replace the image host to the host of a random relay
    // from the current user relay pool.
    final fallbackImageUri = useMemoized(
      () {
        if (userRelays == null) {
          return null;
        }
        final userRelayUri = Uri.parse(userRelays.urls.random);
        final imageUri = Uri.parse(imageUrl);
        return imageUri.replace(host: userRelayUri.host);
      },
      [userRelays, imageUrl],
    );

    if (fallbackImageUri != null) {
      return IonNetworkImage(
        imageUrl: fallbackImageUri.toString(),
        cacheManager: cacheManager,
        imageBuilder: imageBuilder,
        progressIndicatorBuilder: progressIndicatorBuilder,
        fit: fit,
        filterQuality: filterQuality,
        alignment: alignment,
        width: width,
        height: height,
        errorWidget: errorWidget,
      );
    }
    return const IonPlaceholder();
  }
}
