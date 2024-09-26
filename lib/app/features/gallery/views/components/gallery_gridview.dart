import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/gallery/data/models/gallery_state.dart';
import 'package:ice/app/features/gallery/views/components/components.dart';

class GalleryGridview extends StatelessWidget {
  const GalleryGridview({
    required this.galleryState,
    super.key,
  });

  static const _offsetBetweenItems = 4.0;
  static const _itemsPerRow = 3;

  final GalleryState galleryState;

  @override
  Widget build(BuildContext context) {
    // +1 for CameraCell
    final totalItemCount = galleryState.mediaData.length + 1;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerRow,
        crossAxisSpacing: _offsetBetweenItems.s,
        mainAxisSpacing: _offsetBetweenItems.s,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) return const CameraCell();

          final mediaData = galleryState.mediaData[index - 1];

          return ImageCell(
            key: ValueKey(mediaData.asset.id),
            mediaData: mediaData,
          );
        },
        childCount: totalItemCount,
      ),
    );
  }
}
