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
    final controller = useState(PhotoViewController());

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top,
      ),
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(imageUrl),
        loadingBuilder: (context, event) => const CenteredLoadingIndicator(),
        controller: controller.value,
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 6,
        initialScale: PhotoViewComputedScale.contained,
        basePosition: Alignment.center,
        backgroundDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        customSize: MediaQuery.of(context).size,
        scaleStateCycle: (actual) {
          if (actual == PhotoViewScaleState.initial) {
            return PhotoViewScaleState.covering;
          }
          return PhotoViewScaleState.initial;
        },
      ),
    );
  }
}
