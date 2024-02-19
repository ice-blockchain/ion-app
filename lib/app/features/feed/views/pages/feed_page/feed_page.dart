import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/explore_controls/explore_controls.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/stories.dart';

enum FeedType { feed, videos, stories }

class FeedPage extends IceSimplePage {
  const FeedPage(super.route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ScreenSideOffset.small(
                child: Padding(
                  padding: EdgeInsets.only(top: 9.0.s),
                  child: const ExploreControls(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0.s),
                child: const Stories(),
              ),
              const FeedListSeparator(),
            ],
          ),
        ),
      ),
    );
  }
}
