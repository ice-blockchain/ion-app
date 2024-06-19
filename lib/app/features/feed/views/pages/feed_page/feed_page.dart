import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
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

enum FeedType { feed, videos, stories }

class FeedPage extends IceSimplePage {
  const FeedPage(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
    final scrollController = useScrollController();
    final feedCategory = ref.watch(feedCategoryNotifierProvider);

    return PullRightMenuHandler(
      child: Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            FloatingAppBar(
              height: FeedControls.height,
              child: FeedControls(
                pageScrollController: scrollController,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  const Stories(),
                  FeedListSeparator(height: 16.0.s),
                  if (feedCategory == FeedCategory.feed) ...<Widget>[
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
