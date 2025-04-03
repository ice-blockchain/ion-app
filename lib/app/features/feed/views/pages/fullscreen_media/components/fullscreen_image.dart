// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/hooks/use_fullscreen_image_zoom.dart';

class FullscreenImage extends HookConsumerWidget {
  const FullscreenImage({
    required this.imageUrl,
    this.bottomOverlayBuilder,
    this.onInteractionStarted,
    super.key,
  });

  final String imageUrl;
  final Widget Function(BuildContext)? bottomOverlayBuilder;
  final VoidCallback? onInteractionStarted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryTextColor = context.theme.appColors.primaryText;
    final maxScale = 6.0.s;

    final zoomState = useFullscreenImageZoom(ref);

    final handleDoubleTapDown = useCallback(
      (TapDownDetails details) {
        onInteractionStarted?.call();
        zoomState.onDoubleTapDown(details);
      },
      [zoomState, onInteractionStarted],
    );

    final handleDoubleTap = useCallback(
      () {
        onInteractionStarted?.call();
        zoomState.onDoubleTap();
      },
      [zoomState, onInteractionStarted],
    );

    final handleInteractionStart = useCallback(
      (ScaleStartDetails details) {
        onInteractionStarted?.call();
        zoomState.onInteractionStart(details);
      },
      [zoomState, onInteractionStarted],
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: primaryTextColor,
          child: GestureDetector(
            onDoubleTapDown: handleDoubleTapDown,
            onDoubleTap: handleDoubleTap,
            child: InteractiveViewer(
              transformationController: zoomState.transformationController,
              maxScale: maxScale,
              clipBehavior: Clip.none,
              onInteractionStart: handleInteractionStart,
              onInteractionEnd: zoomState.onInteractionEnd,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (_, __) => const CenteredLoadingIndicator(),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        if (bottomOverlayBuilder != null)
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: bottomOverlayBuilder!(context),
          ),
      ],
    );
  }
}
