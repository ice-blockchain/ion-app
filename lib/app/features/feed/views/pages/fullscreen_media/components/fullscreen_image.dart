// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:photo_view/photo_view.dart';

final isImageZoomedProvider = StateProvider<bool>((ref) => false);

class FullscreenImage extends HookConsumerWidget {
  const FullscreenImage({
    required this.imageUrl,
    required this.eventReference,
    super.key,
  });

  final String imageUrl;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaleStateController = PhotoViewScaleStateController();

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
      child: PhotoView(
        key: ValueKey('fullscreen-$imageUrl'),
        imageProvider: CachedNetworkImageProvider(imageUrl),
        loadingBuilder: (_, __) => const CenteredLoadingIndicator(),
        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
        scaleStateController: scaleStateController,
        scaleStateCycle: (state) => state == PhotoViewScaleState.initial
            ? PhotoViewScaleState.covering
            : PhotoViewScaleState.initial,
        minScale: PhotoViewComputedScale.contained,
        initialScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.contained * 3,
      ),
    );
  }
}
