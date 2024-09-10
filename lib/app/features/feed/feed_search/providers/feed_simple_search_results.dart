import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_query_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_simple_search_results.g.dart';

@riverpod
Future<List<String>> feedSimpleSearchResults(FeedSimpleSearchResultsRef ref) async {
  final searchQuery = ref.watch(feedSearchQueryControllerProvider).toLowerCase();
  await ref.debounce(Duration(milliseconds: 300));
  if (searchQuery.isEmpty) {
    return [];
  }
  await Future<void>.delayed(Duration(milliseconds: 500));
  return [searchQuery];
}
