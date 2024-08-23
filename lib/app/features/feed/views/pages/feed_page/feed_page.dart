import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/refreshable_scroll_view/refreshable_scroll_view.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/providers/feed_current_category_provider.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_posts/feed_posts.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/stories.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/trending_videos.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_handler.dart';
import 'package:ice/app/router/components/navigation_app_bar/collapsing_app_bar.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final feedCategory = ref.watch(feedCurrentCategoryProvider);

    return PullRightMenuHandler(
        child: Scaffold(
      body: RefreshableScrollView(
        sliverAppBar: CollapsingAppBar(
          height: FeedControls.height,
          child: FeedControls(
            pageScrollController: scrollController,
          ),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Stories(),
                FeedListSeparator(height: 16.0.s),
                if (feedCategory == FeedCategory.feed) ...[
                  const TrendingVideos(),
                  FeedListSeparator(),
                ],
              ],
            ),
          ),
          const FeedPosts(),
        ],
        onRefresh: () async {
          await Future<void>.delayed(Duration(seconds: 3));
        },
      ),
    ));
  }
}
