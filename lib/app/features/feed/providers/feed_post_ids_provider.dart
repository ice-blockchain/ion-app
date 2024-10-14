// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/data/models/post/post_data.dart';
import 'package:ice/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ice/app/features/feed/providers/posts_storage_provider.dart';
import 'package:ice/app/features/nostr/providers/relays_provider.dart';
import 'package:ice/app/features/user/providers/user_relays_provider.dart';
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
    final userRelays = await ref.read(currentUserRelaysProvider.future);

    if (userRelays == null) {
      throw Exception('User relays are not found');
    }

    final relay = await ref.read(relayProvider(userRelays.list.random.url).future);
    final requestMessage = RequestMessage()
      ..addFilter(const RequestFilter(kinds: [PostData.kind], limit: 20));
    final events = await requestEvents(requestMessage, relay);

    final posts = events.map(PostData.fromEventMessage).toList();

    state = [...state, ...posts.map((post) => post.id)];

    ref.read(postsStorageProvider.notifier).store(posts: posts);
  }
}
