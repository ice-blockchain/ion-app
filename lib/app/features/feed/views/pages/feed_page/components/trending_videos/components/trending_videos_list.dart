// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/features/feed/data/models/trending_videos_overlay.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/mock.dart';

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
      child: LoadMoreBuilder(
        slivers: const [],
        hasMore: true,
        onLoadMore: () async {
          print('VIDEOS LOAD MORE');
          await Future.delayed(const Duration(seconds: 4));
        },
        builder: (context, slivers) {
          return ListView.separated(
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
          );
        },
      ),
    );
  }
}
