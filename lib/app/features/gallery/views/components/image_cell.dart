// SPDX-License-Identifier: ice License 1.0

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
    required this.mediaData,
    super.key,
  });

  final MediaData mediaData;

  static double get cellHeight => 120.0.s;
  static double get cellWidth => 122.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(mediaSelectionStateProvider(mediaData.asset.id));

    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: GestureDetector(
        onTap: () {
          ref.read(mediaSelectionNotifierProvider.notifier).toggleSelection(mediaData.asset.id);
        },
        child: Image(
          image: AssetEntityImageProvider(
            mediaData.asset,
            isOriginal: false,
            thumbnailSize: const ThumbnailSize.square(300),
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
