import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_query_provider.g.dart';

@riverpod
class FeedSearchQueryController extends _$FeedSearchQueryController {
  @override
  String build() => '';

  void update({required String query}) => state = query;
}
