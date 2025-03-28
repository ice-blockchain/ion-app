// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/extensions/extensions.dart';
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
    this.framedEventReference,
    super.key,
  });

  final ModifiablePostEntity post;
  final MediaAttachment media;
  final EventReference eventReference;
  final EventReference? framedEventReference;

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = context.theme.appColors.primaryText;
    final onPrimaryAccentColor = context.theme.appColors.onPrimaryAccent;
    final horizontalPadding = 16.0.s;

    if (media.mediaType == MediaType.video) {
      return VideoPage(
        video: post,
        framedEventReference: framedEventReference,
        looping: true,
      );
    }

    return FullscreenImage(
      imageUrl: media.url,
      eventReference: eventReference,
      bottomOverlayBuilder: (context) => SafeArea(
        top: false,
        child: ColoredBox(
          color: primaryTextColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: CounterItemsFooter(
              eventReference: eventReference,
              color: onPrimaryAccentColor,
              bottomPadding: 0,
              topPadding: 0,
            ),
          ),
        ),
      ),
    );
  }
}
