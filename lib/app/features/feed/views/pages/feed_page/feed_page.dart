// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/app_update_type.dart';
import 'package:ion/app/features/core/views/pages/app_update_modal.dart';
import 'package:ion/app/features/feed/content_notification/views/components/notification_bar_wrapper.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.dart';
import 'package:ion/app/features/feed/providers/feed_trending_videos_data_source_provider.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/article_categories_menu/article_categories_menu.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_posts/feed_posts.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/stories.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/trending_videos.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final feedCategory = ref.watch(feedCurrentFilterProvider.select((state) => state.category));
    final feedHasMore = ref.watch(
      entitiesPagedDataProvider(ref.watch(feedPostsDataSourceProvider))
          .select((state) => (state?.hasMore).falseOrValue),
    );

    useOnInit(
      () {
        if (Random().nextInt(10) == 0) {
          showSimpleBottomSheet<void>(
            isDismissible: false,
            context: context,
            child: const AppUpdateModal(
              appUpdateType: AppUpdateType.updateRequired,
            ),
          );
        }
      },
      <Object>[],
    );

    useScrollTopOnTabPress(context, scrollController: scrollController);

    final slivers = [
      SliverToBoxAdapter(
        child: Column(
          children: [
            if (feedCategory == FeedCategory.articles) const ArticleCategoriesMenu(),
            if (feedCategory != FeedCategory.articles) const Stories(),
            if (feedCategory == FeedCategory.feed) const TrendingVideos(),
          ],
        ),
      ),
      const FeedPosts(),
    ];

    return Scaffold(
      body: NotificationBarWrapper(
        child: LoadMoreBuilder(
          slivers: slivers,
          hasMore: feedHasMore,
          onLoadMore: () => _onLoadMore(ref),
          builder: (context, slivers) {
            return PullToRefreshBuilder(
              sliverAppBar: CollapsingAppBar(
                height: FeedControls.height,
                child: const FeedControls(),
              ),
              slivers: slivers,
              onRefresh: () => _onRefresh(ref),
              refreshIndicatorEdgeOffset: FeedControls.height +
                  MediaQuery.paddingOf(context).top +
                  ScreenTopOffset.defaultMargin,
              builder: (context, slivers) {
                return CustomScrollView(
                  controller: scrollController,
                  slivers: slivers,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    ref
      ..invalidate(entitiesPagedDataProvider(ref.read(feedStoriesDataSourceProvider)))
      ..invalidate(entitiesPagedDataProvider(ref.read(feedPostsDataSourceProvider)))
      ..invalidate(entitiesPagedDataProvider(ref.read(feedTrendingVideosDataSourceProvider)));
  }

  Future<void> _onLoadMore(WidgetRef ref) async {
    await ref
        .read(entitiesPagedDataProvider(ref.read(feedPostsDataSourceProvider)).notifier)
        .fetchEntities();
  }
}
