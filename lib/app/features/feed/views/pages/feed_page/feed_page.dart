// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/content_notificaiton/providers/content_notification_provider.dart';
import 'package:ion/app/features/feed/content_notificaiton/views/components/content_conification_bar.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/feed/providers/feed_post_ids_provider.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/article_categories_menu/article_categories_menu.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_posts/feed_posts.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/stories.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/trending_videos.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/pull_right_menu_handler.dart';
import 'package:ion/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationHeight = 24.0.s;

    final scrollController = useScrollController();
    final feedCategory = ref.watch(feedCurrentFilterProvider.select((state) => state.category));
    final notificationData = ref.watch(contentNotificationControllerProvider);

    useScrollTopOnTabPress(context, scrollController: scrollController);

    final appBarSliver = CollapsingAppBar(
      height: FeedControls.height,
      child: const FeedControls(),
    );

    final slivers = [
      SliverToBoxAdapter(
        child: Column(
          children: [
            if (feedCategory == FeedCategory.articles) ...[
              const ArticleCategoriesMenu(),
              FeedListSeparator(),
            ],
            if (feedCategory != FeedCategory.articles) ...[
              const Stories(),
              FeedListSeparator(height: 16.0.s),
            ],
            if (feedCategory == FeedCategory.feed) ...[
              const TrendingVideos(),
              FeedListSeparator(),
            ],
            Button(
              onPressed: () {
                StoryViewingRoute().push<void>(context);
              },
              label: const Text('View Story'),
            ),
          ],
        ),
      ),
      const FeedPosts(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: 300.ms,
            top: notificationData != null ? notificationHeight : 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: PullRightMenuHandler(
              child: LoadMoreBuilder(
                slivers: slivers,
                hasMore: true,
                onLoadMore: _onLoadMore,
                builder: (context, slivers) {
                  return PullToRefreshBuilder(
                    sliverAppBar: appBarSliver,
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
          ),
          if (notificationData != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ContentNotificationBar(
                key: ValueKey(notificationData),
                data: notificationData,
                height: notificationHeight,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    return ref
        .read(feedPostIdsProvider(filters: ref.read(feedCurrentFilterProvider)).notifier)
        .fetchPosts();
  }

  Future<void> _onLoadMore() async {
    await Future<void>.delayed(const Duration(seconds: 3));
  }
}
