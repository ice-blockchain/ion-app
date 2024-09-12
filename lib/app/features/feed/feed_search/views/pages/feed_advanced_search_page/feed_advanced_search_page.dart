import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_navigation/feed_search_navigation.dart';

class FeedAdvancedSearchPage extends ConsumerWidget {
  const FeedAdvancedSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: not implemented yet
    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            FeedSearchNavigation(),
          ],
        ),
      ),
    );
  }
}
