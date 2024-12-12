// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AttachedMediaPreview extends StatelessWidget {
  const AttachedMediaPreview({
    required this.attachedMediaNotifier,
    super.key,
  });

  final ValueNotifier<List<MediaFile>> attachedMediaNotifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0.s,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.0.s),
        scrollDirection: Axis.horizontal,
        itemCount: attachedMediaNotifier.value.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.0.s),
        itemBuilder: (context, index) {
          final media = attachedMediaNotifier.value[index];
          return _PreviewItem(
            path: media.path,
            onRemove: () {
              attachedMediaNotifier.value = attachedMediaNotifier.value.toList()..remove(media);
            },
          );
        },
      ),
    );
  }
}

class _PreviewItem extends ConsumerWidget {
  const _PreviewItem({required this.path, required this.onRemove});

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetEntity = ref.watch(assetEntityProvider(path)).valueOrNull;
    if (assetEntity == null) {
      return const SizedBox.shrink();
    }

    return SizedBox.square(
      dimension: 50.0.s,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0.s),
              child: SizedBox.square(
                dimension: 44.0.s,
                child: Image(
                  image: AssetEntityImageProvider(
                    assetEntity,
                    isOriginal: false,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: onRemove,
              child: Assets.svg.iconFieldClearmedia.icon(size: 20.0.s),
            ),
          ),
        ],
      ),
    );
  }
}
