// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/ion_connect/data/models/media_attachment.dart';
import 'package:ion/app/services/media_service/aspect_ratio.dart';

class ImageBlockNetworkImage extends StatelessWidget {
  const ImageBlockNetworkImage({
    required this.path,
    required this.media,
    super.key,
  });

  final String path;
  final Map<String, MediaAttachment>? media;

  @override
  Widget build(BuildContext context) {
    final normalizedPath = 'url $path';
    final attachment = media?[normalizedPath];

    if (attachment != null) {
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
