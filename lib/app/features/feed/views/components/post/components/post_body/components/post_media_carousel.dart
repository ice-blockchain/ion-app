import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/model/media_type.dart';
import 'package:ice/app/features/feed/model/post_media.dart';
import 'package:ice/app/features/feed/views/components/post/constants.dart';

class PostMediaCarousel extends HookConsumerWidget {
  const PostMediaCarousel({
    required this.media,
    super.key,
  });

  final List<PostMedia> media;

  List<PostMedia> _filterKnownMedia(List<PostMedia> media) {
    return media
        .where((mediaItem) => mediaItem.mediaType != MediaType.unknown)
        .toList();
  }

  /// Calculates the aspect ratio for a list of media items.
  ///
  /// The aspect ratio is calculated by finding an average of the
  /// dominant category (horizontal or vertical).
  static double _calculateAspectRatio(List<PostMedia> media) {
    final horizontalRatios = <double>[];
    final verticalRatios = <double>[];

    for (final PostMedia(:aspectRatio) in media) {
      if (aspectRatio == null) {
        horizontalRatios.add(PostConstants.maxHorizontalMediaAspectRatio);
      } else if (aspectRatio >= 1) {
        horizontalRatios
            .add(min(PostConstants.maxHorizontalMediaAspectRatio, aspectRatio));
      } else if (aspectRatio < 1) {
        verticalRatios
            .add(max(PostConstants.minVerticalMediaAspectRatio, aspectRatio));
      }
    }

    final ratios = horizontalRatios.length > verticalRatios.length
        ? horizontalRatios
        : verticalRatios;

    return ratios.reduce((a, b) => a + b) / ratios.length;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final knownMedia = useMemoized(() => _filterKnownMedia(media));
    final aspectRatio = useMemoized(() => _calculateAspectRatio(knownMedia));

    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: aspectRatio,
        enableInfiniteScroll: false,
        viewportFraction: media.length > 1 && aspectRatio < 1 ? 0.7 : 1,
      ),
      items: media.map((mediaItem) {
        return Builder(
          builder: (BuildContext context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12.0.s),
              child: switch (mediaItem.mediaType) {
                MediaType.image => _PostMediaImage(
                    imageUrl: mediaItem.url,
                  ),
                MediaType.video => _PostMediaVideo(
                    imageUrl: mediaItem.url,
                  ),
                _ => const SizedBox.shrink(),
              },
            );
          },
        );
      }).toList(),
    );
  }
}

class _PostMediaImage extends StatelessWidget {
  const _PostMediaImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
  }
}

class _PostMediaVideo extends StatelessWidget {
  const _PostMediaVideo({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Placeholder(
        child: Text('Not implemented'),
      ),
    );
  }
}
