// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/features/gallery/providers/media_selection_provider.c.dart';
import 'package:ion/app/features/gallery/views/components/components.dart';
import 'package:ion/app/features/gallery/views/components/duration_badge.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class GalleryGridCell extends ConsumerWidget {
  const GalleryGridCell({
    required this.mediaFile,
    required this.showSelectionBadge,
    this.type = MediaPickerType.common,
    super.key,
  });

  final MediaFile mediaFile;
  final MediaPickerType type;
  final bool showSelectionBadge;

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
          ref
              .read(mediaSelectionNotifierProvider.notifier)
              .toggleSelection(mediaFile.path, type: type);
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
                      if (showSelectionBadge)
                        Positioned(
                          top: 8.0.s,
                          right: 8.0.s,
                          child: SelectionBadge(
                            isSelected: selectionState.isSelected,
                            selectionOrder: selectionState.order.toString(),
                          ),
                        ),
                      if (asset.type == AssetType.video)
                        Positioned(
                          bottom: 4.0.s,
                          right: 4.0.s,
                          child: DurationBadge(
                            duration: asset.duration,
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
