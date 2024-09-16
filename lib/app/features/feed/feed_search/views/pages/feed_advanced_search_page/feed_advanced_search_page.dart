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
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              FeedAdvancedSearchNavigation(query: query),
              TabBar(
                tabAlignment: TabAlignment.start,
                indicatorSize: TabBarIndicatorSize.label,
                padding: EdgeInsets.zero,
                isScrollable: true,
                labelPadding: EdgeInsets.only(left: 0, right: 0),
                tabs: [
                  Row(
                    children: [],
                  ),
                  Tab(
                    icon: Icon(Icons.beach_access_sharp),
                    text: 'Foop',
                  ),
                  Text('Foooooooo'),
                  Tab(
                    icon: Icon(Icons.brightness_5_sharp),
                  ),
                ],
              ),
              Expanded(
                child: const TabBarView(
                  children: [
                    Center(
                      child: Text("It's cloudy here"),
                    ),
                    Center(
                      child: Text("It's rainy here"),
                    ),
                    Center(
                      child: Text("It's sunny here"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
