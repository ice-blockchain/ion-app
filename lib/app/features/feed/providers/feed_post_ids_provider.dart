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
import 'package:ion/app/services/riverpod/notifier_mounted_mixin.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_post_ids_provider.g.dart';
part 'feed_post_ids_provider.freezed.dart';

@freezed
class FeedPostsState with _$FeedPostsState {
  const factory FeedPostsState({
    required FeedFilter filters,
    required Map<String, List<String>> dataSource,
    // Processing pagination params per data source
    required Paged<String, Map<String, PaginationParams>> data,
  }) = _FeedPostsState;
}

@riverpod
class FeedPostIds extends _$FeedPostIds with NotifierMounted {
  @override
  FeedPostsState? build() {
    final filters = ref.watch(feedCurrentFilterProvider.select((state) => state.filter));
    final dataSource = ref.watch(feedDataSourceProvider(filters));

    mount(ref);

    return dataSource.mapOrNull(
      data: (data) => FeedPostsState(
        filters: filters,
        dataSource: data.value,
        data: Paged.data(
          {},
          pagination: {for (final source in data.value.keys) source: PaginationParams()},
        ),
      ),
    );
  }

  Future<void> fetchPosts() async {
    final currentState = state;
    final key = mountedKey;
    if (currentState == null || currentState.dataSource is PagedLoading) {
      return;
    }

    state = currentState.copyWith(
      data: Paged.loading(currentState.data.items, pagination: currentState.data.pagination),
    );

    final paginationEntries = await Future.wait(
      currentState.dataSource.entries.map(_fetchPostsFromDataSource),
    );

    if (mounted(key)) {
      state = state?.copyWith(
        data: Paged.data(
          state!.data.items,
          pagination: Map.fromEntries(paginationEntries),
        ),
      );
    }
  }

  Future<MapEntry<String, PaginationParams>> _fetchPostsFromDataSource(
    MapEntry<String, List<String>> dataSource,
  ) async {
    final key = mountedKey;
    final currentState = state!;
    final paginationParams = currentState.data.pagination[dataSource.key]!;

    if (!paginationParams.hasMore) {
      return MapEntry(dataSource.key, PaginationParams(hasMore: false));
    }

    final requestMessage = RequestMessage()
      ..addFilter(
        RequestFilter(
          kinds: const [PostEntity.kind],
          until: paginationParams.until,
          authors: currentState.filters == FeedFilter.following ? dataSource.value : null,
          limit: 10,
        ),
      );

    final entitiesStream = ref.read(nostrNotifierProvider.notifier).requestEntities(
          requestMessage,
          actionSource: ActionSourceRelayUrl(dataSource.key),
        );

    DateTime? lastEventTime;
    await for (final entity in entitiesStream) {
      if (mounted(key) && entity is PostEntity) {
        lastEventTime = entity.createdAt;
        state = state?.copyWith(
          data: Paged.loading(
            {...state!.data.items}..add(entity.id),
            pagination: state!.data.pagination,
          ),
        );
      }
    }

    return MapEntry(
      dataSource.key,
      PaginationParams(hasMore: lastEventTime != null, lastEventTime: lastEventTime),
    );
  }
}
