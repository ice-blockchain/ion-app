// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:ion/app/features/gallery/providers/media_selection_provider.dart';
import 'package:ion/app/features/gallery/views/components/components.dart';
import 'package:ion/app/services/media_service/media_service.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ImageCell extends ConsumerWidget {
  const ImageCell({
    required this.mediaFile,
    super.key,
  });

  final MediaFile mediaFile;

  static double get cellHeight => 120.0.s;
  static double get cellWidth => 122.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(mediaSelectionStateProvider(mediaFile.path));
    final assetEntityAsync = ref.watch(assetEntityProvider(mediaFile.path));

    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: GestureDetector(
        onTap: () {
          ref.read(mediaSelectionNotifierProvider.notifier).toggleSelection(mediaFile.path);
        },
        child: assetEntityAsync.maybeWhen(
          data: (asset) {
            if (asset == null) {
              return const ShimmerLoadingCell();
            }

            return Image(
              image: AssetEntityImageProvider(
                asset,
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
            );
          },
          orElse: () => const ShimmerLoadingCell(),
        ),
      ),
    );
  }
}
