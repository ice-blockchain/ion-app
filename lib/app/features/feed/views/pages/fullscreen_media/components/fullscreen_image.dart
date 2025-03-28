// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:photo_view/photo_view.dart';

class FullscreenImage extends HookWidget {
  const FullscreenImage({
    required this.imageUrl,
    required this.eventReference,
    this.bottomOverlayBuilder,
    super.key,
  });

  final String imageUrl;
  final EventReference eventReference;
  final Widget Function(BuildContext)? bottomOverlayBuilder;

  @override
  Widget build(BuildContext context) {
    final maxScaleFactor = 6.0.s;
    final primaryTextColor = context.theme.appColors.primaryText;
    final controller = useState(PhotoViewController());
    final scaleState = useState(PhotoViewScaleState.initial);

    return Stack(
      fit: StackFit.expand,
      children: [
        PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
          loadingBuilder: (_, __) => const CenteredLoadingIndicator(),
          controller: controller.value,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * maxScaleFactor,
          initialScale: PhotoViewComputedScale.contained,
          basePosition: Alignment.center,
          backgroundDecoration: BoxDecoration(color: primaryTextColor),
          customSize: MediaQuery.of(context).size,
          tightMode: false,
          scaleStateChangedCallback: (state) => scaleState.value = state,
          scaleStateCycle: (actual) => actual == PhotoViewScaleState.initial
              ? PhotoViewScaleState.covering
              : PhotoViewScaleState.initial,
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
