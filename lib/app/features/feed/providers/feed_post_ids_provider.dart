import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ice/app/features/feed/providers/posts_store_provider.dart';
import 'package:ice/app/features/nostr/constants.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_post_ids_provider.g.dart';

@riverpod
class FeedPostIds extends _$FeedPostIds {
  @override
  List<String> build({required FeedFiltersState filters}) {
    return [];
  }

  Future<void> fetchPosts() async {
    final relay = await ref.read(relaysProvider.notifier).getOrCreate(mainRelay);
    final requestMessage = RequestMessage()
      ..addFilter(const RequestFilter(kinds: <int>[1], limit: 20));
    final events = await requestEvents(requestMessage, relay);

    final posts = events.map(PostData.fromEventMessage).toList();

    state = [...state, ...posts.map((post) => post.id).toList()];

    ref.read(postsStoreProvider.notifier).store(posts: posts);
  }
}
