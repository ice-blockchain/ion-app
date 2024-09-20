import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/camera/data/models/gallery_images_state.dart';
import 'package:ice/app/features/camera/views/components/components.dart';

class GalleryGridview extends StatelessWidget {
  const GalleryGridview({
    super.key,
    required this.state,
    required this.scrollController,
  });

  static double get offsetBetweenItems => 4.0.s;
  static const int itemsPerColumn = 3;

  final GalleryImagesState state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: itemsPerColumn,
        crossAxisSpacing: offsetBetweenItems,
        mainAxisSpacing: offsetBetweenItems,
      ),
      itemCount: state.hasMore ? state.images.length + 2 : state.images.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return const CameraCell();

        if (index <= state.images.length) {
          final imageData = state.images[index - 1];
          return RepaintBoundary(
            key: ValueKey(imageData.id),
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
