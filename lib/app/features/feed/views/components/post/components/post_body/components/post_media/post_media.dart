// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_carousel.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_item.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/utils/post_media.dart';

class PostMedia extends HookConsumerWidget {
  const PostMedia({
    required this.media,
    super.key,
  });

  final List<MediaAttachment> media;

  static List<MediaAttachment> _filterKnownMedia(List<MediaAttachment> media) {
    return media.where((mediaItem) => mediaItem.mediaType != MediaType.unknown).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knownMedia = useMemoized(() => _filterKnownMedia(media));

    final aspectRatio = useMemoized(
      () => calculatePostImageAspectRatio(
        ratioProviders: knownMedia.map(MediaAspectRatio.fromMediaAttachment),
      ),
    );

    if (knownMedia.isEmpty) {
      return const SizedBox.shrink();
    }

    if (knownMedia.length > 1) {
      return PostMediaCarousel(media: knownMedia, aspectRatio: aspectRatio);
    }

    return PostMediaItem(
      mediaItem: knownMedia[0],
      aspectRatio: aspectRatio,
    );
  }
}
