import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_user.dart';
import 'package:ice/app/features/feed/feed_search/providers/mocked_search_users.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_users_provider.g.dart';

@riverpod
Future<List<FeedSearchUser>?> feedSearchUsers(
  FeedSearchUsersRef ref,
  String query,
) async {
  if (query.isEmpty) {
    return null;
  }
  await ref.debounce();
  await Future<void>.delayed(Duration(milliseconds: 500));

  return mockedFeedSearchUsers
      .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
