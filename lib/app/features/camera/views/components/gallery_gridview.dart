import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/camera/data/models/gallery_images_state.dart';
import 'package:ice/app/features/camera/views/components/components.dart';

class GalleryGridview extends StatelessWidget {
  const GalleryGridview({
    super.key,
    required this.galleryState,
    required this.scrollController,
  });

  static const _offsetBetweenItems = 4.0;
  static const _itemsPerColumn = 3;

  final GalleryImagesState galleryState;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _itemsPerColumn,
        crossAxisSpacing: _offsetBetweenItems.s,
        mainAxisSpacing: _offsetBetweenItems.s,
      ),
      itemCount:
          galleryState.hasMore ? galleryState.images.length + 2 : galleryState.images.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return const CameraCell();

        if (index <= galleryState.images.length) {
          final imageData = galleryState.images[index - 1];
          return RepaintBoundary(
            key: ValueKey(imageData.asset.id),
            child: ImageCell(
              imageData: imageData,
            ),
          );
        } else {
          return const ShimmerLoadingCell();
        }
      },
    );
  }
}
