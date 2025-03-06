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
    super.key,
  });

  final ModifiablePostEntity post;
  final MediaAttachment media;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = context.theme.appColors.primaryText;
    final onPrimaryAccentColor = context.theme.appColors.onPrimaryAccent;
    final sizedBoxHeight = 20.0.s;
    final horizontalPadding = 16.0.s;

    return media.mediaType == MediaType.video
        ? VideoPage(
            video: post,
            eventReference: eventReference,
            looping: true,
          )
        : Column(
            children: [
              Expanded(
                child: FullscreenImage(
                  imageUrl: media.url,
                  eventReference: eventReference,
                ),
              ),
              SizedBox(height: sizedBoxHeight),
              ColoredBox(
                color: primaryTextColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: SafeArea(
                    top: false,
                    child: CounterItemsFooter(
                      eventReference: eventReference,
                      color: onPrimaryAccentColor,
                      bottomPadding: 0,
                      topPadding: 0,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
