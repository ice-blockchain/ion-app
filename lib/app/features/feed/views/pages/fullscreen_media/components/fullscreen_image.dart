// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/providers/image_zoom_state.c.dart';
import 'package:photo_view/photo_view.dart';

class FullscreenImage extends HookConsumerWidget {
  const FullscreenImage({
    required this.imageUrl,
    this.bottomOverlayBuilder,
    super.key,
  });

  final String imageUrl;
  final Widget Function(BuildContext)? bottomOverlayBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maxScaleFactor = 6.0.s;
    final primaryTextColor = context.theme.appColors.primaryText;
    final scaleState = useState(PhotoViewScaleState.initial);

    return Stack(
      fit: StackFit.expand,
      children: [
        PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
          loadingBuilder: (_, __) => const CenteredLoadingIndicator(),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * maxScaleFactor,
          initialScale: PhotoViewComputedScale.contained,
          basePosition: Alignment.center,
          backgroundDecoration: BoxDecoration(color: primaryTextColor),
          tightMode: false,
          scaleStateChangedCallback: (state) {
            scaleState.value = state;
            ref.read(imageZoomStateProvider.notifier).setZoomed(state);
          },
          scaleStateCycle: (actual) => actual == PhotoViewScaleState.initial
              ? PhotoViewScaleState.covering
              : PhotoViewScaleState.initial,
          gestureDetectorBehavior: HitTestBehavior.opaque,
        ),
        if (bottomOverlayBuilder != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: bottomOverlayBuilder!(context),
          ),
      ],
    );
  }
}
