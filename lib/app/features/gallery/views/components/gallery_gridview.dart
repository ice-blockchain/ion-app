// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/gallery/data/models/gallery_state.dart';
import 'package:ice/app/features/gallery/views/components/components.dart';

class GalleryGridview extends StatelessWidget {
  const GalleryGridview({
    required this.galleryState,
    this.withShimmer = false,
    super.key,
  });

  static const _offsetBetweenItems = 4.0;
  static const _itemsPerRow = 3;
  static const _shimmerItemCount = 30;

  final GalleryState galleryState;
  final bool withShimmer;

  @override
  Widget build(BuildContext context) {
    final totalItemCount =
        withShimmer ? _shimmerItemCount : galleryState.mediaData.length + 1; // +1 for CameraCell

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerRow,
        crossAxisSpacing: _offsetBetweenItems.s,
        mainAxisSpacing: _offsetBetweenItems.s,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (withShimmer) return const ShimmerLoadingCell();

          if (index == 0) return const CameraCell();

          final mediaData = galleryState.mediaData[index - 1];

          return ImageCell(
            key: ValueKey(mediaData.path),
            mediaFile: mediaData,
          );
        },
        childCount: totalItemCount,
      ),
    );
  }
}
