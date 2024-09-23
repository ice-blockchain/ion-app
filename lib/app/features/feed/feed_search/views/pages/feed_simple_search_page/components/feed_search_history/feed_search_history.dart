import 'package:flutter/widgets.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_history/feed_search_history_header.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_history/feed_search_history_query_list_item.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_history/feed_search_history_user_list_item.dart';

class FeedSearchHistory extends StatelessWidget {
  const FeedSearchHistory({
    super.key,
    required this.userIds,
    required this.queries,
  });

  final List<String> userIds;

  final List<String> queries;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          SizedBox(height: 20.0.s),
          FeedSearchHistoryHeader(),
          if (userIds.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16.0.s),
              child: SizedBox(
                height: 105.0.s,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
                  scrollDirection: Axis.horizontal,
                  itemCount: userIds.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.0.s),
                  itemBuilder: (context, index) =>
                      FeedSearchHistoryUserListItem(userId: userIds[index]),
                ),
              ),
            ),
          if (queries.isNotEmpty)
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                itemCount: queries.length,
                itemBuilder: (context, index) =>
                    FeedSearchHistoryQueryListItem(query: queries[index]),
              ),
            )
        ],
      ),
    );
  }
}
