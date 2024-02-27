import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list/components/trending_videos_list_item.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/mock.dart';

enum TrendingVideosListOverlay {
  horizontal,
  vertical;

  Size get itemSize {
    return switch (this) {
      TrendingVideosListOverlay.horizontal => Size(240.0.s, 160.0.s),
      TrendingVideosListOverlay.vertical => Size(140.0.s, 220.0.s),
    };
  }
}

class TrendingVideosList extends StatelessWidget {
  const TrendingVideosList({
    super.key,
    required this.listOverlay,
  });

  final TrendingVideosListOverlay listOverlay;

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
          return SizedBox(width: 12.0.s);
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
