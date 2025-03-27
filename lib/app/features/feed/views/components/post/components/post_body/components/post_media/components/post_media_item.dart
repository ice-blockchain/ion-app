// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/image/ion_network_image.dart';
import 'package:ion/app/components/video_preview/video_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/typedefs/typedefs.dart';

class PostMediaItem extends HookWidget {
  const PostMediaItem({
    required this.mediaItem,
    required this.aspectRatio,
    required this.eventReference,
    this.mediaIndex = 0,
    this.framedEventReference,
    this.onVideoTap,
    super.key,
  });

  final MediaAttachment mediaItem;
  final int mediaIndex;
  final double aspectRatio;
  final EventReference eventReference;
  final EventReference? framedEventReference;
  final OnVideoTapCallback? onVideoTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey(mediaItem.url),
      onTap: () => onVideoTap != null && mediaItem.mediaType == MediaType.video
          ? onVideoTap?.call(
              eventReference: eventReference.encode(),
              initialMediaIndex: mediaIndex,
              framedEventReference: framedEventReference?.encode(),
            )
          : FullscreenMediaRoute(
              eventReference: eventReference.encode(),
              initialMediaIndex: mediaIndex,
              framedEventReference: framedEventReference?.encode(),
            ).push<void>(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0.s),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: switch (mediaItem.mediaType) {
            MediaType.image => IonNetworkImage(
                imageUrl: mediaItem.url,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            MediaType.video => VideoPreview(
                videoUrl: mediaItem.url,
                thumbnailUrl: mediaItem.thumb,
                framedEventReference: framedEventReference,
              ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
