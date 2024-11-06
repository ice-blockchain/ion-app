// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/components/section_header/section_header.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/providers/feed_trending_videos_data_source_provider.dart';
import 'package:ion/app/features/feed/providers/trending_videos_overlay_provider.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_skeleton.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/video_icon.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';

class TrendingVideos extends ConsumerWidget {
  const TrendingVideos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listOverlay = ref.watch(trendingVideosOverlayNotifierProvider);
    final dataSource = ref.watch(feedTrendingVideosDataSourceProvider);
    final videosData = ref.watch(entitiesPagedDataProvider(dataSource));

    return Column(
      children: [
        SectionHeader(
          onPress: () {},
          title: context.i18n.feed_trending_videos,
          leadingIcon: const VideosIcon(),
        ),
        if (videosData == null)
          TrendingVideosListSkeleton(listOverlay: listOverlay)
        else
          LoadMoreBuilder(
            slivers: [
              TrendingVideosList(
                entities: videosData.data.items.toList(),
                listOverlay: listOverlay,
              ),
            ],
            hasMore: videosData.hasMore,
            onLoadMore: () => _onLoadMore(ref),
            builder: (context, slivers) => SizedBox(
              height: listOverlay.itemSize.height,
              child: CustomScrollView(
                scrollDirection: Axis.horizontal,
                slivers: slivers,
              ),
            ),
          ),
        SizedBox(height: 18.0.s),
      ],
    );
  }

  Future<void> _onLoadMore(WidgetRef ref) async {
    await ref
        .read(entitiesPagedDataProvider(ref.read(feedTrendingVideosDataSourceProvider)).notifier)
        .fetchEntities();
  }
}
