// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_attachment.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_image.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_video.dart';

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
          MediaType.image => PostMediaImage(
              imageUrl: mediaItem.url,
              aspectRatio: aspectRatio,
            ),
          MediaType.video => PostMediaVideo(
              videoUrl: mediaItem.url,
            ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
