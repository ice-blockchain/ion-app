import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post_media_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/components/post_media/components/post_media_item.dart';

class PostMediaCarousel extends HookConsumerWidget {
  const PostMediaCarousel({
    required this.media,
    required this.aspectRatio,
    super.key,
  });

  static const double verticalViewportFraction = 0.7;

  final List<PostMediaData> media;

  final double aspectRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (aspectRatio < 1) {
      final itemWidth =
          MediaQuery.of(context).size.width * verticalViewportFraction;
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

    return CarouselSlider.builder(
      options: CarouselOptions(
        aspectRatio: aspectRatio,
        enableInfiniteScroll: false,
        viewportFraction: 1,
      ),
      itemCount: media.length,
      itemBuilder: (context, index, realIndex) {
        return PostMediaItem(
          mediaItem: media[index],
          aspectRatio: aspectRatio,
        );
      },
    );
  }
}
