import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/components/scroll_view/load_more_builder.dart';
import 'package:ice/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/providers/feed_post_ids_provider.dart';
import 'package:ice/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/article_categories_menu/article_categories_menu.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_posts/feed_posts.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/stories.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/trending_videos.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_handler.dart';
import 'package:ice/app/hooks/use_scroll_top_on_tab_press.dart';
import 'package:ice/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final feedCategory = ref.watch(feedCurrentFilterProvider.select((state) => state.category));

    useScrollTopOnTabPress(context, scrollController: scrollController);

    final appBarSliver = CollapsingAppBar(
      height: FeedControls.height,
      child: FeedControls(),
    );

    final slivers = [
      SliverToBoxAdapter(
        child: Column(
          children: [
            if (feedCategory == FeedCategory.articles) ...[
              ArticleCategoriesMenu(),
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
          ],
        ),
      ),
      const FeedPosts(),
    ];

    return PullRightMenuHandler(
      child: Scaffold(
        body: LoadMoreBuilder(
          slivers: slivers,
          hasMore: true,
          onLoadMore: () => _onLoadMore(),
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
    );
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    return ref
        .read(feedPostIdsProvider(filters: ref.read(feedCurrentFilterProvider)).notifier)
        .fetchPosts();
  }

  Future<void> _onLoadMore() async {
    await Future<void>.delayed(Duration(seconds: 3));
  }
}
