import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_navigation/feed_advanced_search_navigation.dart';

class FeedAdvancedSearchPage extends ConsumerWidget {
  const FeedAdvancedSearchPage({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            FeedAdvancedSearchNavigation(query: query),
          ],
        ),
      ),
    );
  }
}
