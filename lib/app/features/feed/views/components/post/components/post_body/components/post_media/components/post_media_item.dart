// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ion/app/components/video_preview/video_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';

class PostMediaItem extends StatelessWidget {
  const PostMediaItem({
    required this.mediaItem,
    required this.aspectRatio,
    super.key,
  });

  final MediaAttachment mediaItem;

  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0.s),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: switch (mediaItem.mediaType) {
          MediaType.image => CachedNetworkImage(
              imageUrl: mediaItem.url,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => const SizedBox.shrink(),
            ),
          MediaType.video => VideoPreview(
              videoUrl: mediaItem.url,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
