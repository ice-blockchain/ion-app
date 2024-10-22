// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/components/feed_search_history/feed_search_history_user_list_item.dart';
import 'package:ion/app/features/search/views/components/feed_search_history/search_history_query_list_item.dart';
import 'package:ion/app/features/search/views/components/search_history/search_history_header.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({
    required this.userIds,
    required this.queries,
    required this.onSelectQuery,
    required this.onClearHistory,
    super.key,
  });

  final List<String> userIds;

  final List<String> queries;

  final void Function(String query) onSelectQuery;
  final VoidCallback onClearHistory;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          SizedBox(height: 20.0.s),
          SearchHistoryHeader(
            onClearHistory: onClearHistory,
          ),
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
                itemBuilder: (context, index) {
                  final query = queries[index];
                  return FeedSearchHistoryQueryListItem(
                    query: queries[index],
                    onTap: () {
                      onSelectQuery(query);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
