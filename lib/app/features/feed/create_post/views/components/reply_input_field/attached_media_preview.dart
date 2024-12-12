// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AttachedMediaPreview extends ConsumerWidget {
  const AttachedMediaPreview({required this.path, required this.onRemove, super.key});

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
