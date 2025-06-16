// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_following_content_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_request_queue.c.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/providers/relevant_current_user_relays_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/functions.dart';
import 'package:ion/app/utils/pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_for_you_content_provider.c.freezed.dart';
part 'feed_for_you_content_provider.c.g.dart';

@riverpod
class FeedForYouContent extends _$FeedForYouContent implements PagedNotifier {
  @override
  FeedForYouContentState build(FeedType feedType, {FeedModifier? feedModifier}) {
    Future.microtask(fetchEntities);
    ref.listen(
      feedFollowingContentProvider(feedType, feedModifier: feedModifier, showSeen: false),
      noop,
    );
    return const FeedForYouContentState(
      items: null,
      isLoading: false,
      hasMoreFollowing: true,
      relaysPagination: {},
    );
  }

  @override
  Future<void> fetchEntities() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      await for (final entity in requestEntities(limit: feedType.pageSize)) {
        state = state.copyWith(items: {...(state.items ?? {}), entity});
      }
      _ensureEmptyState();
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Stream<IonConnectEntity> requestEntities({required int limit}) async* {
    var unseenFollowing = 0;
    await for (final entity in _fetchUnseenFollowing(limit: limit)) {
      yield entity;
      unseenFollowing++;
    }
    if (unseenFollowing < limit) {
      yield* _fetchInterestsEntities(limit: limit - unseenFollowing);
    }
  }

  Stream<IonConnectEntity> _fetchUnseenFollowing({required int limit}) async* {
    final notifier = ref.read(
      feedFollowingContentProvider(feedType, feedModifier: feedModifier, showSeen: false).notifier,
    );
    final provider = ref
        .read(feedFollowingContentProvider(feedType, feedModifier: feedModifier, showSeen: false));
    if (!provider.hasMore) return;

    yield* notifier.requestEntities(limit: limit);

    if (!provider.hasMore) {
      state = state.copyWith(hasMoreFollowing: false);
    }
  }

  Stream<IonConnectEntity> _fetchInterestsEntities({required int limit}) async* {
    final dataSourceRelays = await _getDataSourceRelays();

    await _initRelaysPagination(relays: dataSourceRelays);

    final nextPageRelays = getNextPageSources(sources: state.relaysPagination, limit: limit);

    if (nextPageRelays.isEmpty) return;

    var requestedCount = 0;
    await for (final entity in _requestEntitiesFromRelays(relays: nextPageRelays.keys)) {
      yield entity;
      requestedCount++;
    }

    final remaining = limit - requestedCount;

    if (remaining > 0) {
      yield* _fetchInterestsEntities(limit: remaining);
    }
  }

  Future<List<String>> _getDataSourceRelays() {
    return ref.read(relevantCurrentUserRelaysProvider.future);
  }

  Future<void> _initRelaysPagination({required List<String> relays}) async {
    if (state.relaysPagination.isNotEmpty) return;

    final interests = await ref.read(feedUserInterestsProvider(feedType).future);

    final relaysPagination = {
      for (final relay in relays)
        relay: RelayPagination(
          page: -1,
          hasMore: true,
          interestsPagination: {
            for (final interest in interests.subcategories)
              interest.key: const InterestPagination(hasMore: true),
          },
        ),
    };

    state = state.copyWith(relaysPagination: relaysPagination);
  }

  Stream<IonConnectEntity> _requestEntitiesFromRelays({
    required Iterable<String> relays,
  }) async* {
    final requestsQueue = await ref.read(feedRequestQueueProvider.future);
    final resultsController = StreamController<IonConnectEntity>();

    final requests = [
      for (final relay in relays)
        requestsQueue.add(() async {
          //TODO:impl fetching
        }).catchError((Object? error) {
          Logger.error(
            error ?? '',
            message: 'Error requesting entities from relay: $relay',
          );
        }),
    ];

    unawaited(Future.wait(requests).whenComplete(resultsController.close));

    yield* resultsController.stream;
  }

  @override
  void refresh() {
    if (!state.isLoading) ref.invalidateSelf();
  }

  @override
  void insertEntity(IonConnectEntity entity) {
    state = state.copyWith(items: {entity, ...(state.items ?? {})});
  }

  @override
  void deleteEntity(IonConnectEntity entity) {
    final items = state.items;
    if (items == null) return;

    final updatedItems = {...items};
    final removed = updatedItems.remove(entity);

    if (removed) {
      state = state.copyWith(items: updatedItems);
    }
  }

  void _ensureEmptyState() {
    if (state.items == null) {
      state = state.copyWith(items: const {});
    }
  }
}

@Freezed(equal: false)
class FeedForYouContentState with _$FeedForYouContentState implements PagedState {
  const factory FeedForYouContentState({
    required Set<IonConnectEntity>? items,
    required Map<String, RelayPagination> relaysPagination,
    required bool hasMoreFollowing,
    required bool isLoading,
  }) = _FeedForYouContentState;

  const FeedForYouContentState._();

  @override
  bool get hasMore =>
      hasMoreFollowing || relaysPagination.values.any((pagination) => pagination.hasMore);
}

@Freezed(equal: false)
class RelayPagination with _$RelayPagination implements PagedSource {
  const factory RelayPagination({
    required int page,
    required bool hasMore,
    required Map<String, InterestPagination> interestsPagination,
  }) = _RelayPagination;
}

@Freezed(equal: false)
class InterestPagination with _$InterestPagination {
  const factory InterestPagination({
    required bool hasMore,
    int? lastEventCreatedAt,
  }) = _InterestPagination;
}
