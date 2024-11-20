// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/gallery/data/models/gallery_state.dart';
import 'package:ion/app/features/gallery/views/components/components.dart';

class GalleryGridView extends StatelessWidget {
  const GalleryGridView({
    required this.galleryState,
    this.type = MediaType.image,
    super.key,
  });

  static const _offsetBetweenItems = 4.0;
  static const _itemsPerRow = 3;

  final GalleryState galleryState;
  final MediaType type;

  @override
  Widget build(BuildContext context) {
    final photosTotalCount = galleryState.mediaData.length + 1; // +1 for CameraCell

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerRow,
        crossAxisSpacing: _offsetBetweenItems.s,
        mainAxisSpacing: _offsetBetweenItems.s,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0 && type == MediaType.image) {
            return const CameraCell();
          }

          final adjustedIndex = type == MediaType.image ? index - 1 : index;

          final mediaData = galleryState.mediaData[adjustedIndex];
          return GalleryGridCell(
            key: ValueKey(mediaData.path),
            mediaFile: mediaData,
          );
        },
        childCount: type == MediaType.image ? photosTotalCount : galleryState.mediaData.length,
      ),
    );
  }
}
