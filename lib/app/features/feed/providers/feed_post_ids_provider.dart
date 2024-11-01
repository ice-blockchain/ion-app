// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/core/model/paged.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/feed/providers/feed_data_source.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_post_ids_provider.g.dart';
part 'feed_post_ids_provider.freezed.dart';

@freezed
class FeedPostsState with _$FeedPostsState {
  const factory FeedPostsState({
    required FeedFilter filters,
    required Map<String, List<String>> dataSource,
    required Paged<String, Map<String, PaginationParams>> data,
  }) = _FeedPostsState;
}

@riverpod
class FeedPostIds extends _$FeedPostIds {
  @override
  Future<FeedPostsState> build() async {
    final filters = ref.watch(feedCurrentFilterProvider.select((state) => state.filter));
    final dataSource = await ref.watch(feedDataSourceProvider(filters).future);

    return FeedPostsState(
      filters: filters,
      dataSource: dataSource,
      data: Paged.data(
        {},
        pagination: {for (final source in dataSource.keys) source: PaginationParams()},
      ),
    );
  }

  Future<void> fetchPosts() async {
    if (stateValue is PagedLoading || stateValue == null) {
      return;
    }

    final lastEventTimes = await Future.wait(
      stateValue.dataSource.entries.map((dataSourceEntry) async {
        final requestMessage = RequestMessage()
          ..addFilter(const RequestFilter(kinds: [PostEntity.kind], limit: 20));
        final entitiesStream = ref.read(nostrNotifierProvider.notifier).requestEntities(
              requestMessage,
              actionSource: ActionSourceRelayUrl(dataSourceEntry.key),
            );
        DateTime? lastEventTime;
        await for (final entity in entitiesStream) {
          if (entity is PostEntity) {
            lastEventTime = entity.createdAt;
            state = state
          }
        }
        return lastEventTime;
      }),
    );

    // state = AsyncData(
    //   Paged.data(
    //     state.items,
    //     pagination: Map.fromIterable(
    //       dataSource.entries,
    //       key: (element) => element,
    //     ),
    //   ),
    // );
  }
}
