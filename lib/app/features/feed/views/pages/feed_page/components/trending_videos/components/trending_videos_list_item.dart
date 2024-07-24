import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/model/trending_videos_overlay.dart';
import 'package:ice/app/features/feed/model/video_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_author.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_likes_button.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_menu_button.dart';

class TrendingVideoListItem extends HookConsumerWidget {
  const TrendingVideoListItem({
    required this.video,
    required this.onTap,
    super.key,
  });

  final VideoData video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemSize =
        (video.isVertical ? TrendingVideosOverlay.vertical : TrendingVideosOverlay.horizontal)
            .itemSize;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: itemSize.width,
        child: SizedBox(
          height: itemSize.height,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0.s),
              image: DecorationImage(
                image: CachedNetworkImageProvider(video.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        ),
      ),
    );
  }
}
