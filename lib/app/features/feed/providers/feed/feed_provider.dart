import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/providers/feed/feed_current_category_provider.dart';
import 'package:ice/app/features/feed/providers/posts_store_provider.dart';
import 'package:ice/app/features/nostr/constants.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_provider.g.dart';

typedef State = Map<FeedCategory, List<String>>;

@riverpod
class FeedPosts extends _$FeedPosts {
  @override
  State build() {
    return Map.unmodifiable({});
  }

  Future<void> fetchPosts() async {
    final currentCategory = ref.read(feedCurrentCategoryProvider);
    final relay = await ref.read(relaysProvider.notifier).getOrCreate(mainRelay);
    final requestMessage = RequestMessage()
      ..addFilter(const RequestFilter(kinds: <int>[1], limit: 20));
    final events = await requestEvents(requestMessage, relay);

    final posts = events.map(PostData.fromEventMessage).toList();

    ref.read(postsStoreProvider.notifier).storePosts(posts);

    state = Map.unmodifiable({
      ...state,
      currentCategory: posts.map((post) => post.id).toList(),
    });
  }
}

@riverpod
List<PostData> feedCurrentCategoryPosts(FeedCurrentCategoryPostsRef ref) {
  final currentCategory = ref.watch(feedCurrentCategoryProvider);
  final currentCategoryPostIds = ref.watch(feedPostsProvider)[currentCategory] ?? [];
  final postsStore = ref.watch(postsStoreProvider);

  return currentCategoryPostIds.map((id) => postsStore[id]!).toList();
}
