// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/data/models/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/image_carousel.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/single_media_view.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/video_carousel.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/data/models/media_attachment.dart';

class MediaContentHandler extends HookConsumerWidget {
  const MediaContentHandler({
    required this.post,
    required this.eventReference,
    required this.initialMediaIndex,
    this.framedEventReference,
    super.key,
  });

  final ModifiablePostEntity post;
  final EventReference eventReference;
  final EventReference? framedEventReference;
  final int initialMediaIndex;

  static List<MediaAttachment> _filterKnownMedia(List<MediaAttachment> media) {
    return media.where((mediaItem) => mediaItem.mediaType != MediaType.unknown).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMedia = useMemoized(
      () => _filterKnownMedia(post.data.media.values.toList()),
      [post.data.media],
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
