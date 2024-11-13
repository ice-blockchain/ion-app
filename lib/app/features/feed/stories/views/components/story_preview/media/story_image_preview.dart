// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class StoryImagePreview extends StatelessWidget {
  const StoryImagePreview({
    required this.path,
    super.key,
  });

  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: Consumer(
        builder: (context, ref, _) {
          final assetEntityAsync = ref.watch(assetEntityProvider(path));

          return assetEntityAsync.maybeWhen(
            data: (asset) {
              if (asset == null) {
                return const CenteredLoadingIndicator();
              }

              return Image(
                image: AssetEntityImageProvider(
                  asset,
                  isOriginal: false,
                  thumbnailSize: const ThumbnailSize.square(600),
                ),
                fit: BoxFit.cover,
              );
            },
            orElse: () => const CenteredLoadingIndicator(),
          );
        },
      ),
    );
  }
}
