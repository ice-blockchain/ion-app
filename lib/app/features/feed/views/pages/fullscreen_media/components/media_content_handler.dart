// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/image_carousel.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/single_media_view.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/video_carousel.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

class MediaContentHandler extends HookConsumerWidget {
  const MediaContentHandler({
    required this.eventReference,
    required this.initialMediaIndex,
    this.post,
    this.article,
    this.framedEventReference,
    super.key,
  }) : assert(post != null || article != null, 'Either post or article must be provided');

  final ModifiablePostEntity? post;
  final ArticleEntity? article;
  final EventReference eventReference;
  final EventReference? framedEventReference;
  final int initialMediaIndex;

  static List<MediaAttachment> _filterKnownMedia(List<MediaAttachment> media) {
    return media.where((mediaItem) => mediaItem.mediaType != MediaType.unknown).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMedia = useMemoized(
      () {
        final media = post?.data.media ?? article?.data.media ?? {};
        return _filterKnownMedia(media.values.toList());
      },
      [post?.data.media, article?.data.media],
    );

    if (allMedia.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentIndex = initialMediaIndex.clamp(0, allMedia.length - 1);
    final selectedMedia = allMedia[currentIndex];

    final isVideoSelected = selectedMedia.mediaType == MediaType.video;

    final filteredMedia = useMemoized(
      () => allMedia.where((media) => media.mediaType == selectedMedia.mediaType).toList(),
      [allMedia, selectedMedia.mediaType],
    );

    if (filteredMedia.length <= 1) {
      return SingleMediaView(
        post: post,
        article: article,
        media: selectedMedia,
        eventReference: eventReference,
        framedEventReference: framedEventReference,
      );
    }

    final filteredIndex = filteredMedia.indexWhere((media) => media.url == selectedMedia.url);
    final startIndex = filteredIndex >= 0 ? filteredIndex : 0;

    return isVideoSelected
        ? VideoCarousel(
            post: post,
            article: article,
            videos: filteredMedia,
            initialIndex: startIndex,
            eventReference: eventReference,
            framedEventReference: framedEventReference,
          )
        : ImageCarousel(
            images: filteredMedia,
            initialIndex: startIndex,
            eventReference: eventReference,
          );
  }
}
