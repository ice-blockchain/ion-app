// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/feed/providers/feed_data_source.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_post_ids_provider.g.dart';

@riverpod
class FeedPostIds extends _$FeedPostIds {
  @override
  Future<List<String>> build() async {
    final filters = ref.watch(feedCurrentFilterProvider.select((state) => state.filter));
    final dataSource = await ref.watch(feedDataSourceProvider(filters).future);

    unawaited(fetchPosts(dataSource));

    return [];
  }

  Future<void> fetchPosts(Map<String, List<String>> dataSource) async {
    for (final dataSourceEntry in dataSource.entries) {
      final requestMessage = RequestMessage()
        ..addFilter(const RequestFilter(kinds: [PostEntity.kind], limit: 20));
      final entitiesStream = ref
          .read(nostrNotifierProvider.notifier)
          .requestEntities(requestMessage, actionSource: ActionSourceRelayUrl(dataSourceEntry.key));
      await for (final entity in entitiesStream) {
        if (entity is PostEntity) {
          state = AsyncData([...(state.valueOrNull ?? {}), entity.id]);
        }
      }
    }
  }
}
