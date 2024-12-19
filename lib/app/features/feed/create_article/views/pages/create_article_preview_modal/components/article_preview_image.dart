// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_image/read_time_tile.dart';
import 'package:ion/app/features/feed/views/components/article/constants.dart';
import 'package:ion/app/features/gallery/providers/providers.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ArticlePreviewImage extends StatelessWidget {
  const ArticlePreviewImage({
    this.mediaFile,
    this.minutesToRead,
    this.minutesToReadAlignment = Alignment.bottomRight,
    super.key,
  });

  final MediaFile? mediaFile;
  final int? minutesToRead;
  final Alignment minutesToReadAlignment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0.s),
      child: Stack(
        alignment: minutesToReadAlignment,
        children: [
          AspectRatio(
            aspectRatio: ArticleConstants.headerImageAspectRation,
            child: Consumer(
              builder: (context, ref, _) {
                if (mediaFile == null) {
                  return const ColoredBox(color: Colors.grey);
                }

                final assetEntityAsync = ref.watch(assetEntityProvider(mediaFile!.path));

                return assetEntityAsync.maybeWhen(
                  data: (asset) {
                    if (asset == null) {
                      return const ColoredBox(color: Colors.grey);
                    }
                    return Image(
                      image: AssetEntityImageProvider(
                        asset,
                        isOriginal: false,
                        thumbnailSize: const ThumbnailSize.square(300),
                      ),
                      fit: BoxFit.cover,
                    );
                  },
                  orElse: SizedBox.shrink,
                );
              },
            ),
          ),
          if (minutesToRead != null)
            ReadTimeTile(
              alignment: minutesToReadAlignment,
              minutesToRead: minutesToRead!,
              borderRadius: 12.0.s,
            ),
        ],
      ),
    );
  }
}
