import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/feed/model/trending_videos_overlay.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_item.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_separator.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/mock.dart';

class TrendingVideosList extends StatelessWidget {
  const TrendingVideosList({
    required this.listOverlay,
    super.key,
  });

  final TrendingVideosOverlay listOverlay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: listOverlay.itemSize.height,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: trendingVideos.length,
        separatorBuilder: (BuildContext context, int index) {
          return const TrendingVideosListSeparator();
        },
        itemBuilder: (BuildContext context, int index) {
          return TrendingVideoListItem(
            video: trendingVideos[index],
            itemSize: listOverlay.itemSize,
          );
        },
      ),
    );
  }
}
