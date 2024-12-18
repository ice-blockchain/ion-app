// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/media_service/aspect_ratio.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class LocalImage extends ConsumerWidget {
  const LocalImage({
    required this.path,
    super.key,
  });

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assetEntity = ref.watch(assetEntityProvider(path)).valueOrNull;
    if (assetEntity == null) {
      return const SizedBox.shrink();
    }

    final aspectRatio = attachedMediaAspectRatio(
      [MediaAspectRatio.fromAssetEntity(assetEntity)],
    ).aspectRatio;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Image(
        image: AssetEntityImageProvider(
          assetEntity,
          isOriginal: false,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
