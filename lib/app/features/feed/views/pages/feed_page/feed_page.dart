import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/components/post/post.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/feed_controls.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/stories.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/trending_videos.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/pull_right_menu_handler.dart';

enum FeedType { feed, videos, stories }

class FeedPage extends IceSimplePage {
  const FeedPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ScrollController scrollController = useScrollController();

    return PullRightMenuHandler(
      child: Scaffold(
        body: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: ScreenTopOffset(
                child: Column(
                  children: <Widget>[
                    FeedControls(
                      pageScrollController: scrollController,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0.s),
                      child: const Stories(),
                    ),
                    FeedListSeparator(
                      height: 16.0.s,
                    ),
                    const TrendingVideos(),
                    FeedListSeparator(),
                  ],
                ),
              ),
            ),
            SliverList.separated(
              itemCount: 20,
              separatorBuilder: (BuildContext context, int index) {
                return FeedListSeparator();
              },
              itemBuilder: (BuildContext context, int index) {
                return const Post();
              },
            ),
          ],
        ),
      ),
    );
  }
}
