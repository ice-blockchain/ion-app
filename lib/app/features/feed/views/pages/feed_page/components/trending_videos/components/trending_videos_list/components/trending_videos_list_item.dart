import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list/components/trending_video_author.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list/components/trending_video_likes_button.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list/components/trending_video_menu_button.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/mock.dart';

class TrendingVideoListItem extends StatelessWidget {
  const TrendingVideoListItem({
    required this.video,
    required this.itemSize,
  });

  final TrendingVideo video;
  final Size itemSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
          children: <Widget>[
            SizedBox(
              height: 40.0.s,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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
