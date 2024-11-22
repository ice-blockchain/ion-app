// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/data/models/gallery_state.dart';
import 'package:ion/app/features/gallery/views/components/components.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';

class GalleryGridView extends StatelessWidget {
  const GalleryGridView({
    required this.galleryState,
    this.type = MediaPickerType.common,
    super.key,
  });

  static const _offsetBetweenItems = 4.0;
  static const _itemsPerRow = 3;

  final GalleryState galleryState;
  final MediaPickerType type;

  @override
  Widget build(BuildContext context) {
    final totalCount = galleryState.mediaData.length + 1; // +1 for CameraCell

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerRow,
        crossAxisSpacing: _offsetBetweenItems.s,
        mainAxisSpacing: _offsetBetweenItems.s,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            return const CameraCell();
          }

          final mediaData = galleryState.mediaData[index];
          return GalleryGridCell(
            key: ValueKey(mediaData.path),
            mediaFile: mediaData,
            type: type,
          );
        },
        childCount: totalCount,
      ),
    );
  }
}
