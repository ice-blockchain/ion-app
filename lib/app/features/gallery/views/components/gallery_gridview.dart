// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/data/models/gallery_state.dart';
import 'package:ion/app/features/gallery/views/components/components.dart';
import 'package:ion/app/features/gallery/views/components/video_cell.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';

class GalleryGridview extends StatelessWidget {
  const GalleryGridview({
    required this.galleryState,
    this.type = MediaPickerType.image,
    super.key,
  });

  static const _offsetBetweenItems = 4.0;
  static const _itemsPerRow = 3;

  final GalleryState galleryState;

  final MediaPickerType type;

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
          final mediaData = galleryState.mediaData[index - 1];

          if (mediaData.mimeType == 'photo') {
            if (index == 0) return const CameraCell();
            return ImageCell(
              key: ValueKey(mediaData.path),
              mediaFile: mediaData,
            );
          } else if (mediaData.mimeType == 'video') {
            return VideoCell(
              key: ValueKey(mediaData.path),
              mediaFile: mediaData,
            );
          }
          return null;
        },
        childCount:
            type == MediaPickerType.image ? photosTotalCount : galleryState.mediaData.length,
      ),
    );
  }
}
