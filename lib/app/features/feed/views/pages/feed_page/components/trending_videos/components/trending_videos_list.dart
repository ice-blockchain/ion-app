// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/trending_videos_overlay.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_separator.dart';

class TrendingVideosList extends StatelessWidget {
  const TrendingVideosList({
    required this.videos,
    required this.listOverlay,
    super.key,
  });

  final List<PostEntity> videos;

  final TrendingVideosOverlay listOverlay;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSideOffset.defaultSmallMargin,
      ),
      sliver: SliverList.separated(
        itemCount: videos.length,
        separatorBuilder: (BuildContext context, int index) {
          return const TrendingVideosListSeparator();
        },
        itemBuilder: (BuildContext context, int index) => TrendingVideoListItem(
          video: videos[index],
          itemSize: listOverlay.itemSize,
        ),
      ),
    );
  }
}
