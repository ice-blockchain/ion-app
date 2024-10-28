// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_attachment.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_carousel.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_item.dart';
import 'package:ion/app/features/feed/views/components/post/constants.dart';

class PostMedia extends HookConsumerWidget {
  const PostMedia({
    required this.media,
    super.key,
  });

  final List<MediaAttachment> media;

  static List<MediaAttachment> _filterKnownMedia(List<MediaAttachment> media) {
    return media.where((mediaItem) => mediaItem.mediaType != MediaType.unknown).toList();
  }

  /// Calculates the aspect ratio for a list of media items.
  ///
  /// The aspect ratio is calculated by finding an average of the
  /// dominant category (horizontal or vertical).
  static double _calculateAspectRatio({required List<MediaAttachment> media}) {
    if (media.isEmpty) {
      return 0;
    }

    final horizontalRatios = <double>[];
    final verticalRatios = <double>[];

    for (final MediaAttachment(:aspectRatio) in media) {
      if (aspectRatio == null) {
        horizontalRatios.add(PostConstants.maxHorizontalMediaAspectRatio);
      } else if (aspectRatio >= 1) {
        horizontalRatios.add(min(PostConstants.maxHorizontalMediaAspectRatio, aspectRatio));
      } else if (aspectRatio < 1) {
        verticalRatios.add(max(PostConstants.minVerticalMediaAspectRatio, aspectRatio));
      }
    }

    final ratios =
        horizontalRatios.length > verticalRatios.length ? horizontalRatios : verticalRatios;

    return ratios.reduce((a, b) => a + b) / ratios.length;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knownMedia = useMemoized(() => _filterKnownMedia(media));

    final aspectRatio = useMemoized(
      () => _calculateAspectRatio(media: knownMedia),
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
