// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_image.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/video/views/pages/video_page.dart';

class SingleMediaView extends StatelessWidget {
  const SingleMediaView({
    required this.post,
    required this.media,
    required this.eventReference,
    super.key,
  });

  final ModifiablePostEntity post;
  final MediaAttachment media;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return media.mediaType == MediaType.video
        ? VideoPage(
            video: post,
            eventReference: eventReference,
            looping: true,
          )
        : FullscreenImage(
            imageUrl: media.url,
            eventReference: eventReference,
          );
  }
}
