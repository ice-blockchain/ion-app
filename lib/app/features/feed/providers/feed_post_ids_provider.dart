// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
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
    final requestMessage = RequestMessage()
      ..addFilter(const RequestFilter(kinds: [PostData.kind], limit: 20));
    final eventsStream = ref.read(nostrNotifierProvider.notifier).request(requestMessage);
    await for (final event in eventsStream) {
      final postData = PostData.fromEventMessage(event);
      ref.read(nostrCacheProvider.notifier).cache(postData);
      state = [...state, postData.id];
    }
  }
}
