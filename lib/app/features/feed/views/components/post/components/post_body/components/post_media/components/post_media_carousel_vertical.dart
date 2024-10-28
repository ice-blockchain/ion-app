// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_item.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';

class PostMediaCarouselVertical extends StatelessWidget {
  const PostMediaCarouselVertical({
    required this.media,
    required this.aspectRatio,
    super.key,
  });

  static const double _viewportFraction = 0.7;

  final List<MediaAttachment> media;

  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final itemWidth = MediaQuery.of(context).size.width * _viewportFraction;
    return SizedBox(
      height: itemWidth / aspectRatio,
      child: ListView.separated(
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
            ),
          );
        },
      ),
    );
  }
}
