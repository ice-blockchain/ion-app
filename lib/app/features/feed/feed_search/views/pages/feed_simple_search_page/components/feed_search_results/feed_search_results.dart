import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_results/feed_search_results_list_item.dart';

class FeedSearchResults extends ConsumerWidget {
  const FeedSearchResults({
    required this.userIds,
    super.key,
  });

  static double get listVerticalOffset => 14.0.s;

  final List<String> userIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: listVerticalOffset),
        itemCount: userIds.length,
        itemBuilder: (context, index) {
          return FeedSearchResultsListItem(userId: userIds[index]);
        },
      ),
    );
  }
}
