// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/video_preview/video_preview.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/media_service/aspect_ratio.dart';

class ImageBlockNetworkImage extends HookConsumerWidget {
  const ImageBlockNetworkImage({
    required this.path,
    required this.media,
    super.key,
    this.authorPubkey,
  });

  final String path;
  final Map<String, MediaAttachment>? media;
  final String? authorPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final normalizedPath = 'url $path';
    final attachment = media?[normalizedPath];

    if (attachment != null) {
      final mediaType = MediaType.fromMimeType(attachment.mimeType);

      if (mediaType == MediaType.video) {
        final mediaAspectRatio = MediaAspectRatio.fromMediaAttachment(attachment);
        final aspectRatio = mediaAspectRatio.aspectRatio ?? 16 / 9;

        return AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: VideoPreview(
              videoUrl: path,
              authorPubkey: authorPubkey ?? '',
              thumbnailUrl: attachment.thumb,
            ),
          ),
        );
      }

      final mediaAspectRatio = MediaAspectRatio.fromMediaAttachment(attachment);
      if (mediaAspectRatio.aspectRatio != null) {
        final aspectRatio = attachedMediaAspectRatio([mediaAspectRatio]).aspectRatio;

        return AspectRatio(
          aspectRatio: aspectRatio,
          child: Image.network(
            path,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
          ),
        );
      }
    }

    return const SizedBox.shrink();
  }
}
