// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/data/models/gallery_state.c.dart';
import 'package:ion/app/features/gallery/views/components/components.dart';
import 'package:ion/app/features/gallery/views/components/media/add_media_cell.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';

class GalleryGridView extends StatelessWidget {
  const GalleryGridView({
    required this.galleryState,
    required this.showSelectionBadge,
    this.type = MediaPickerType.common,
    super.key,
  });

  static const _offsetBetweenItems = 4.0;
  static const _itemsPerRow = 3;

  final GalleryState galleryState;
  final MediaPickerType type;
  final bool showSelectionBadge;

  @override
  Widget build(BuildContext context) {
    final indexOffset = galleryState.limitedAccess ? 2 : 1; // +1 for CameraCell, +1 for AddCell
    final totalCount = galleryState.mediaData.length + indexOffset;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerRow,
        crossAxisSpacing: _offsetBetweenItems.s,
        mainAxisSpacing: _offsetBetweenItems.s,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return CameraCell(type: type);
          }

          if (index == 1 && galleryState.limitedAccess) {
            return AddMediaCell(type: type);
          }

          final indexOffset = galleryState.limitedAccess ? 2 : 1;

          final mediaData = galleryState.mediaData[index - indexOffset];
          return GalleryGridCell(
            key: ValueKey(mediaData.path),
            mediaFile: mediaData,
            type: type,
            showSelectionBadge: showSelectionBadge,
          );
        },
        childCount: totalCount,
      ),
    );
  }
}
