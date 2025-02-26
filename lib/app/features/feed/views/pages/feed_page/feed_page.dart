// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_posts_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_stories_data_source_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_trending_videos_data_source_provider.c.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/article_categories_menu/article_categories_menu.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/feed_posts_list/feed_posts_list.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/stories.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/trending_videos.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedCategory = ref.watch(feedCurrentFilterProvider.select((state) => state.category));
    final hasMorePosts =
        ref.watch(feedPostsProvider.select((state) => state?.hasMore)).falseOrValue;
    final showTrendingVideos = useRef(
      ref.watch(featureFlagsProvider.notifier).get(FeedFeatureFlag.showTrendingVideo),
    );

    useScrollTopOnTabPress(context, scrollController: PrimaryScrollController.of(context));

    final slivers = [
      SliverToBoxAdapter(
        child: Column(
          children: [
            if (feedCategory == FeedCategory.articles) const ArticleCategoriesMenu(),
            if (feedCategory != FeedCategory.articles) const Stories(),
            if (feedCategory == FeedCategory.feed && showTrendingVideos.value)
              const TrendingVideos(),
          ],
        ),
      ),
      const FeedPostsList(),
    ];

    return Scaffold(
      body: LoadMoreBuilder(
        slivers: slivers,
        hasMore: hasMorePosts,
        onLoadMore: () => ref.watch(feedPostsProvider.notifier).loadMore(),
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
            builder: (context, slivers) => CustomScrollView(slivers: slivers),
          );
        },
      ),
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    ref
      ..invalidate(entitiesPagedDataProvider(ref.read(feedStoriesDataSourceProvider)))
      ..invalidate(entitiesPagedDataProvider(ref.read(feedPostsDataSourceProvider)))
      ..invalidate(entitiesPagedDataProvider(ref.read(feedTrendingVideosDataSourceProvider)))
      ..invalidate(feedFilterRelaysProvider);
  }
}
