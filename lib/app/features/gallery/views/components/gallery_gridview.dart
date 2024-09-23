import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/gallery/data/models/gallery_images_state.dart';
import 'package:ice/app/features/gallery/views/components/components.dart';

class GalleryGridview extends StatelessWidget {
  const GalleryGridview({
    super.key,
    required this.galleryState,
    required this.scrollController,
  });

  static const _offsetBetweenItems = 4.0;
  static const _itemsPerRow = 3;

  final ScrollController scrollController;
  final GalleryImagesState galleryState;

  @override
  Widget build(BuildContext context) {
    // +1 for CameraCell
    final totalItemCount = galleryState.images.length + 1;

    return GridView.builder(
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerRow,
        crossAxisSpacing: _offsetBetweenItems.s,
        mainAxisSpacing: _offsetBetweenItems.s,
      ),
      itemCount: totalItemCount,
      itemBuilder: (context, index) {
        if (index == 0) return const CameraCell();

        final imageIndex = index - 1;

        if (imageIndex >= galleryState.images.length) {
          return const SizedBox.shrink();
        }

        final imageData = galleryState.images[imageIndex];

        return ImageCell(
          key: ValueKey(imageData.asset.id),
          imageData: imageData,
        );
      },
    );
  }
}
