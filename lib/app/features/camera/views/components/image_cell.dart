import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/camera/data/models/image_data.dart';
import 'package:ice/app/features/camera/providers/providers.dart';
import 'package:ice/app/features/camera/views/components/components.dart';

class ImageCell extends ConsumerWidget {
  const ImageCell({
    super.key,
    required this.imageData,
  });

  final ImageData imageData;

  static const double cellHeight = 120.0;
  static const double cellWidth = 122.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(imageSelectionStateProvider(imageData.id));
    final thumbnailAsync = ref.watch(thumbnailDataProvider(imageData.asset.id));

    return SizedBox(
      width: cellWidth.s,
      height: cellHeight.s,
      child: GestureDetector(
        onTap: () {
          final success =
              ref.read(imageSelectionNotifierProvider.notifier).toggleSelection(imageData);
          if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Max ${ref.read(maxSelectionProvider)} images.'),
              ),
            );
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            thumbnailAsync.maybeWhen(
              data: (thumbData) => thumbData != null
                  ? Image.memory(
                      thumbData,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox.shrink(),
              orElse: () => const ShimmerLoadingCell(),
            ),
            if (selectionState.isSelected)
              Positioned(
                top: 8.0.s,
                right: 8.0.s,
                child: SelectionBadge(
                  selectionOrder: selectionState.order.toString(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
