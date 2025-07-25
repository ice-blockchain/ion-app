// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.r.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.m.dart';
import 'package:ion/app/features/feed/providers/feed_posts_provider.r.dart';
import 'package:ion/app/features/feed/providers/feed_trending_videos_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/current_user_story_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/feed_stories_provider.r.dart';
import 'package:ion/app/features/feed/stories/providers/user_stories_provider.r.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/article_categories_menu/article_categories_menu.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_navigation/feed_notifications_button.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_posts_list/feed_posts_list.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/stories.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/trending_videos.dart';
import 'package:ion/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedCategory = ref.watch(feedCurrentFilterProvider.select((state) => state.category));
    final hasMorePosts = ref.watch(feedPostsProvider.select((state) => state.hasMore)).falseOrValue;
    final showTrendingVideosFeatureFlag = useRef(
      ref.watch(featureFlagsProvider.notifier).get(FeedFeatureFlag.showTrendingVideo),
    );
    final scrollController = useScrollController();

    useScrollTopOnTabPress(context, scrollController: scrollController);

    final showStories = feedCategory != FeedCategory.articles;
    final showTrendingVideos = showTrendingVideosFeatureFlag.value &&
        (feedCategory == FeedCategory.feed || feedCategory == FeedCategory.videos);

    final slivers = [
      SliverToBoxAdapter(
        child: Column(
          children: [
            if (feedCategory == FeedCategory.articles) const ArticleCategoriesMenu(),
            if (showStories) const Stories(),
            if (showTrendingVideos) const TrendingVideos(),
          ],
        ),
      ),
      const FeedPostsList(),
    ];

    return Scaffold(
      body: LoadMoreBuilder(
        slivers: slivers,
        hasMore: hasMorePosts,
        onLoadMore: () => _onLoadMore(ref),
        builder: (context, slivers) {
          return PullToRefreshBuilder(
            sliverAppBar: CollapsingAppBar(
              height: FeedControls.height,
              topOffset: ScreenTopOffset.defaultMargin - FeedNotificationsButton.counterOffset,
              child: FeedControls(scrollController: scrollController),
            ),
            slivers: slivers,
            onRefresh: () =>
                _onRefresh(ref, showStories: showStories, showTrendingVideos: showTrendingVideos),
            refreshIndicatorEdgeOffset: FeedControls.height +
                MediaQuery.paddingOf(context).top +
                ScreenTopOffset.defaultMargin,
            builder: (context, slivers) => CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: slivers,
              controller: scrollController,
            ),
          );
        },
      ),
    );
  }

  Future<void> _onLoadMore(WidgetRef ref) async {
    return ref.read(feedPostsProvider.notifier).fetchEntities();
  }

  Future<void> _onRefresh(
    WidgetRef ref, {
    required bool showStories,
    required bool showTrendingVideos,
  }) async {
    ref.read(feedPostsProvider.notifier).refresh();
    if (showTrendingVideos) {
      ref.read(feedTrendingVideosProvider.notifier).refresh();
    }
    if (showStories) {
      ref.read(feedStoriesProvider.notifier).refresh();
      ref.read(currentUserStoryProvider.notifier).refresh();
      ref.read(userStoriesProvider(ref.read(currentPubkeySelectorProvider)!).notifier).refresh();
    }
  }
}
