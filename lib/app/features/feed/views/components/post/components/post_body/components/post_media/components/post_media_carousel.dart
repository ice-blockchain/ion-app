// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_carousel_horizontal.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_carousel_vertical.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';

class PostMediaCarousel extends StatelessWidget {
  const PostMediaCarousel({
    required this.media,
    required this.aspectRatio,
    super.key,
  });

  final List<MediaAttachment> media;

  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    if (aspectRatio < 1) {
      return PostMediaCarouselVertical(media: media, aspectRatio: aspectRatio);
    }

    return PostMediaCarouselHorizontal(media: media, aspectRatio: aspectRatio);
  }
}
