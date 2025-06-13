// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/ion_connect_network_image/ion_connect_network_image.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/hooks/use_image_zoom.dart';

class FullscreenImage extends HookConsumerWidget {
  const FullscreenImage({
    required this.imageUrl,
    required this.authorPubkey,
    this.bottomOverlayBuilder,
    super.key,
  });

  final String imageUrl;
  final String authorPubkey;
  final Widget Function(BuildContext)? bottomOverlayBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryTextColor = context.theme.appColors.primaryText;
    final maxScale = 6.0.s;

    final zoomController = useImageZoom(ref);

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: primaryTextColor,
          child: GestureDetector(
            onDoubleTapDown: zoomController.onDoubleTapDown,
            onDoubleTap: zoomController.onDoubleTap,
            child: InteractiveViewer(
              transformationController: zoomController.transformationController,
              maxScale: maxScale,
              clipBehavior: Clip.none,
              onInteractionStart: zoomController.onInteractionStart,
              onInteractionUpdate: zoomController.onInteractionUpdate,
              onInteractionEnd: zoomController.onInteractionEnd,
              child: IonConnectNetworkImage(
                imageUrl: imageUrl,
                authorPubkey: authorPubkey,
                placeholder: const CenteredLoadingIndicator(),
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
