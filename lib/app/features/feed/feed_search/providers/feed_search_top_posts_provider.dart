import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/providers/posts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_top_posts_provider.g.dart';

@riverpod
Future<List<String>?> feedSearchTopPosts(
  FeedSearchTopPostsRef ref,
  String query,
) async {
  if (query.isEmpty) {
    return null;
  }
  await ref.debounce();
  await Future<void>.delayed(Duration(milliseconds: 500));

  return ref.read(postsProvider).categoryPostIds[FeedCategory.feed]?.sublist(0, 3) ?? [];
}
