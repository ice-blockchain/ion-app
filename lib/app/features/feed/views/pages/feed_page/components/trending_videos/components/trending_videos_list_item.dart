import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/model/trending_videos_overlay.dart';
import 'package:ice/app/features/feed/providers/trending_videos_overlay_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_author.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_likes_button.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_menu_button.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/mock.dart';

class TrendingVideoListItem extends HookConsumerWidget {
  const TrendingVideoListItem({
    required this.video,
    required this.itemSize,
    super.key,
  });

  final TrendingVideo video;
  final Size itemSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(trendingVideosOverlayNotifierProvider.notifier).overlay =
            ref.read(trendingVideosOverlayNotifierProvider) == TrendingVideosOverlay.horizontal
                ? TrendingVideosOverlay.vertical
                : TrendingVideosOverlay.horizontal;
      },
      child: Container(
        width: itemSize.width,
        height: itemSize.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0.s),
          image: DecorationImage(
            image: CachedNetworkImageProvider(video.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40.0.s,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TrendingVideoLikesButton(
                    likes: video.likes,
                    onPressed: () {},
                  ),
                  TrendingVideoMenuButton(onPressed: () {}),
                ],
              ),
            ),
            TrendingVideoAuthor(
              imageUrl: video.authorImageUrl,
              label: video.authorName,
            ),
          ],
        ),
      ),
    );
  }
}
