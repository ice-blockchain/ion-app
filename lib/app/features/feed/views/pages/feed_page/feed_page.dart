import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/providers/feed_category_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/post_list/post_list.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/stories.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/trending_videos.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_handler.dart';
import 'package:ice/app/router/components/floating_app_bar/floating_app_bar.dart';

class FeedPage extends HookConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final feedCategory = ref.watch(feedCategoryNotifierProvider);

    return PullRightMenuHandler(
      child: Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          slivers: [
            FloatingAppBar(
              height: FeedControls.height,
              child: FeedControls(
                pageScrollController: scrollController,
              ),
            ),
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
            const Posts(),
          ],
        ),
      ),
    );
  }
}
