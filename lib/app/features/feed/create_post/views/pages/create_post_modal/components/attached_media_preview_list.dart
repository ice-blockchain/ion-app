// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/media_service/aspect_ratio.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AttachedMediaPreview extends ConsumerWidget {
  const AttachedMediaPreview({
    required this.attachedMediaNotifier,
    super.key,
  });

  final ValueNotifier<List<MediaFile>> attachedMediaNotifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = attachedMediaNotifier.value;

    final maxItemHeight = 190.0.s;
    final attachedMediaAspectRatio = list.isEmpty
        ? 0.0
        : calculatePostImageAspectRatio(
            ratioProviders: list.map(MediaAspectRatio.fromMediaFile),
          );
    final isHorizontalPreviews = attachedMediaAspectRatio >= 1;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxItemHeight,
      ),
      child: ListView.separated(
        padding: EdgeInsets.only(right: ScreenSideOffset.defaultSmallMargin),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final file = attachedMediaNotifier.value[i];

          final assetEntity = ref.watch(assetEntityProvider(file.path)).valueOrNull;
          if (assetEntity == null) {
            return const SizedBox.shrink();
          }

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxItemHeight,
              maxWidth: 300.0.s,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0.s),
                  child: AspectRatio(
                    aspectRatio: attachedMediaAspectRatio,
                    child: Image(
                      image: AssetEntityImageProvider(
                        assetEntity,
                        isOriginal: false,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      attachedMediaNotifier.value = attachedMediaNotifier.value.toList()
                        ..remove(file);
                    },
                    icon: Assets.svg.iconFieldClearall.icon(
                      size: isHorizontalPreviews ? 24.0.s : 16.0.s,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 12.0.s),
        itemCount: attachedMediaNotifier.value.length,
      ),
    );
  }
}
