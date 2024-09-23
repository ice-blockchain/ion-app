import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/gallery/data/models/media_data.dart';
import 'package:ice/app/features/gallery/providers/media_selection_provider.dart';
import 'package:ice/app/features/gallery/views/components/components.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ImageCell extends ConsumerWidget {
  const ImageCell({
    super.key,
    required this.imageData,
  });

  final MediaData imageData;

  static const double cellHeight = 120.0;
  static const double cellWidth = 122.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(mediaSelectionStateProvider(imageData.asset.id));

    return SizedBox(
      width: cellWidth.s,
      height: cellHeight.s,
      child: GestureDetector(
        onTap: () {
          ref.read(mediaSelectionNotifierProvider.notifier).toggleSelection(imageData.asset.id);
        },
        child: Image(
          image: AssetEntityImageProvider(
            imageData.asset,
            isOriginal: false,
            thumbnailSize: const ThumbnailSize.square(300),
            thumbnailFormat: ThumbnailFormat.jpeg,
          ),
          fit: BoxFit.cover,
          frameBuilder: (_, Widget child, int? frame, bool wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    top: 8.0.s,
                    right: 8.0.s,
                    child: SelectionBadge(
                      isSelected: selectionState.isSelected,
                      selectionOrder: selectionState.order.toString(),
                    ),
                  ),
                ],
              );
            } else {
              return const ShimmerLoadingCell();
            }
          },
          errorBuilder: (_, __, ___) => const ShimmerLoadingCell(),
        ),
      ),
    );
  }
}
