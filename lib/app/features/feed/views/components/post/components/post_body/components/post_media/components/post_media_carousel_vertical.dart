// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_item.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

class PostMediaCarouselVertical extends StatelessWidget {
  const PostMediaCarouselVertical({
    required this.media,
    required this.aspectRatio,
    required this.eventReference,
    super.key,
  });

  static const double _viewportFraction = 0.7;

  final List<MediaAttachment> media;
  final double aspectRatio;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.sizeOf(context).width * _viewportFraction;
    return SizedBox(
      height: itemWidth / aspectRatio,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        itemCount: media.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 12.0.s,
          );
        },
        itemBuilder: (context, index) {
          return SizedBox(
            width: itemWidth,
            child: PostMediaItem(
              mediaItem: media[index],
              aspectRatio: aspectRatio,
              eventReference: eventReference,
            ),
          );
        },
      ),
    );
  }
}
