// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/features/feed/data/models/post/post_media_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_carousel_horizontal.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_carousel_vertical.dart';

class PostMediaCarousel extends StatelessWidget {
  const PostMediaCarousel({
    required this.media,
    required this.aspectRatio,
    super.key,
  });

  final List<PostMediaData> media;

  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    if (aspectRatio < 1) {
      return PostMediaCarouselVertical(media: media, aspectRatio: aspectRatio);
    }

    return PostMediaCarouselHorizontal(media: media, aspectRatio: aspectRatio);
  }
}
