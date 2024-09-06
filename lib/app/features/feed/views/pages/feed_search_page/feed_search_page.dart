import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/features/feed/views/pages/feed_search_page/components/feed_search_navigation.dart';

class FeedSearchPage extends StatelessWidget {
  const FeedSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTopOffset(child: FeedSearchNavigation()),
    );
  }
}
