// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_image.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_video.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class FullScreenMediaBody extends StatelessWidget {
  const FullScreenMediaBody({
    required this.mediaUrl,
    required this.mediaType,
    required this.eventReference,
    super.key,
  });

  final String mediaUrl;
  final MediaType mediaType;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: mediaType == MediaType.video
          ? FullscreenVideo(
              videoUrl: mediaUrl,
              eventReference: eventReference,
            )
          : FullscreenImage(
              imageUrl: mediaUrl,
              eventReference: eventReference,
            ),
    );
  }
}
