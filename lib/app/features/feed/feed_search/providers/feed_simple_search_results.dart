import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_user.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_query_provider.dart';
import 'package:ice/app/features/feed/feed_search/providers/mocked_search_users.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_simple_search_results.g.dart';

@riverpod
Future<List<FeedSearchUser>?> feedSimpleSearchResults(FeedSimpleSearchResultsRef ref) async {
  final searchQuery = ref.watch(feedSearchQueryControllerProvider).toLowerCase();
  if (searchQuery.isEmpty) {
    return null;
  }
  await ref.debounce();
  await Future<void>.delayed(Duration(milliseconds: 500));

  return feedSearchUsers
      .where((user) => user.name.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
}
