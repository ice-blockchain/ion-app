// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/data/models/trending_videos_overlay.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_item.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/mock.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';

class TrendingVideosList extends StatelessWidget {
  const TrendingVideosList({
    required this.entities,
    required this.listOverlay,
    super.key,
  });

  final List<NostrEntity> entities;

  final TrendingVideosOverlay listOverlay;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSideOffset.defaultSmallMargin,
      ),
      sliver: SliverList.separated(
        itemCount: entities.length,
        separatorBuilder: (BuildContext context, int index) {
          return const TrendingVideosListSeparator();
        },
        itemBuilder: (BuildContext context, int index) {
          final entity = entities[index];
          if (entity is PostEntity) {
            //TODO::use entity for data instead of mocked videos
          }
          return TrendingVideoListItem(
            video: TrendingVideo(
              imageUrl: 'https://picsum.photos/500/800?random=$index',
              authorName: '@john',
              authorImageUrl: 'https://i.pravatar.cc/150?u=@john$index',
              likes: Random().nextInt(10000000),
            ),
            itemSize: listOverlay.itemSize,
          );
        },
      ),
    );
  }
}
