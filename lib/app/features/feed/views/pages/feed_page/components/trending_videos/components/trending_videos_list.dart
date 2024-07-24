import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/feed/model/trending_videos_overlay.dart';
import 'package:ice/app/features/feed/model/video_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_item.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_separator.dart';
import 'package:ice/app/router/app_routes.dart';

class TrendingVideosList extends HookWidget {
  const TrendingVideosList({
    required this.trendingVideos,
    super.key,
  });

  final List<VideoData> trendingVideos;

  @override
  Widget build(BuildContext context) {
    final hasVerticalVideos = useMemoized(
      () {
        return trendingVideos.any((videoData) => videoData.isVertical);
      },
      <Object?>[trendingVideos],
    );
    return SizedBox(
      height:
          (hasVerticalVideos ? TrendingVideosOverlay.vertical : TrendingVideosOverlay.horizontal)
              .itemSize
              .height,
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
            onTap: () => VideosFeedRoute($extra: trendingVideos).push<void>(context),
          );
        },
      ),
    );
  }
}
