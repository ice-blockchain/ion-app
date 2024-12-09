// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/components/section_header/section_header.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/trending_videos_overlay.dart';
import 'package:ion/app/features/feed/providers/feed_trending_videos_data_source_provider.c.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_skeleton.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/video_icon.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class TrendingVideos extends ConsumerWidget {
  const TrendingVideos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Determine the actual overlay type.
    // final listOverlay = ref.watch(trendingVideosOverlayNotifierProvider);
    const listOverlay = TrendingVideosOverlay.vertical;

    final dataSource = ref.watch(feedTrendingVideosDataSourceProvider);
    // TODO: Replace with the actual `entitiesPagedDataProvider` when real data is available.
    // final videosData = ref.watch(entitiesPagedDataProvider(dataSource));
    final videosData = ref.watch(mockPostEntitiesPagedDataProvider(dataSource));
    final videos = videosData?.data.items;

    if (videos == null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.s),
        child: const TrendingVideosListSkeleton(
          listOverlay: listOverlay,
        ),
      );
    }

    if (videos.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SectionHeader(
          onPress: () {
            final eventReference = EventReference.fromNostrEntity(videos.first);
            VideosRoute(eventReference: eventReference.toString()).push<void>(context);
          },
          title: context.i18n.feed_trending_videos,
          leadingIcon: const VideosIcon(),
        ),
        LoadMoreBuilder(
          slivers: [
            TrendingVideosList(
              videos: videos.whereType<PostEntity>().toList(),
              listOverlay: listOverlay,
            ),
          ],
          hasMore: videosData!.hasMore,
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
        FeedListSeparator(),
      ],
    );
  }

  Future<void> _onLoadMore(WidgetRef ref) async {
    await ref
        .read(
          // TODO: Replace with the actual `entitiesPagedDataProvider` when real data is available.
          mockPostEntitiesPagedDataProvider(ref.read(feedTrendingVideosDataSourceProvider))
              .notifier,
        )
        .fetchEntities();
  }
}
