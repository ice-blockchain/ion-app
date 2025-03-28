// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:photo_view/photo_view.dart';

class FullscreenImage extends HookWidget {
  const FullscreenImage({
    required this.imageUrl,
    required this.eventReference,
    super.key,
  });

  final String imageUrl;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(PhotoViewController.new, []);
    final scaleStateController = useMemoized(PhotoViewScaleStateController.new, []);
    final isZoomed = useState(false);

    useEffect(
      () {
        return () {
          controller.dispose();
          scaleStateController.dispose();
        };
      },
      [controller, scaleStateController],
    );

    PhotoViewScaleState customScaleStateCycle(PhotoViewScaleState current) {
      if (current == PhotoViewScaleState.initial) {
        return PhotoViewScaleState.covering;
      } else {
        return PhotoViewScaleState.initial;
      }
    }

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top,
      ),
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(imageUrl),
        loadingBuilder: (context, event) => const CenteredLoadingIndicator(),
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        backgroundDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        controller: controller,
        scaleStateController: scaleStateController,
        scaleStateChangedCallback: (state) {
          isZoomed.value = state != PhotoViewScaleState.initial;
        },
        scaleStateCycle: customScaleStateCycle,
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
        initialScale: PhotoViewComputedScale.contained,
      ),
    );
  }
}
