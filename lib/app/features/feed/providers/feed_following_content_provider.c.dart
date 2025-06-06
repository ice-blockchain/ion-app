// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:async/async.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/data/repository/following_feed_seen_events_repository.c.dart';
import 'package:ion/app/features/feed/providers/feed_config_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_data_source_builders.dart';
import 'package:ion/app/features/feed/providers/feed_request_queue.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_following_content_provider.c.freezed.dart';
part 'feed_following_content_provider.c.g.dart';

@riverpod
class FeedFollowingContent extends _$FeedFollowingContent implements PagedNotifier {
  @override
  FeedFollowingContentState build(FeedType feedType, [FeedModifier? feedModifier]) {
    Future(fetchEntities);
    return const FeedFollowingContentState(
      items: null,
      pagination: {},
    );
  }

  /// Fetches entities for the feed by populating the state by fetching entities
  /// for each followed pubkey one by one.
  ///
  /// The page size is determined by the `FeedType.pageSize`
  /// The max createdAt of the events we request from the relays is determined by the `FeedConfig.followingReqMaxAge`
  /// The max number of concurrent requests is determined by `FeedConfig.concurrentRequests`
  @override
  Future<void> fetchEntities({bool bypassLoading = false, int? limit}) async {
    if (_loading && !bypassLoading) return;

    _loading = true;

    try {
      final fetchLimit = limit ?? feedType.pageSize;

      final dataSourcePubkeys = await _getDataSourcePubkeys();
      if (dataSourcePubkeys.isEmpty) {
        _ensureEmptyState();
        return;
      }

      state = state.copyWith(
        pagination: _initPagination(pubkeys: dataSourcePubkeys),
      );

      final nextPagePubkeys = await _getNextPagePubkeys(
        pubkeys: dataSourcePubkeys,
        limit: fetchLimit,
      );

      if (nextPagePubkeys.isEmpty) {
        _ensureEmptyState();
        return;
      }

      final results = await _fetchEntities(pubkeys: nextPagePubkeys);
      final remaining = fetchLimit - results.nonNulls.length;

      if (remaining > 0) {
        return fetchEntities(limit: remaining, bypassLoading: true);
      }
    } finally {
      _loading = false;
    }
  }

  @override
  void refresh() {
    ref.invalidateSelf();
  }

  @override
  void insertEntity(IonConnectEntity entity) {
    state = state.copyWith(
      items: {entity, ...(state.items ?? {})},
    );
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

  bool _loading = false;

  void _ensureEmptyState() {
    if (state.items == null) {
      state = state.copyWith(items: const {});
    }
  }

  Future<List<String>> _getDataSourcePubkeys() async {
    final followList = await ref.read(currentUserFollowListProvider.future);

    if (followList == null) {
      throw FollowListNotFoundException();
    }

    var pubkeysToFetch = followList.data.list.map((followee) => followee.pubkey);

    // In case of stories - we also need to fetch own entities
    if (feedType == FeedType.story) {
      final currentPubkey = ref.read(currentPubkeySelectorProvider);
      if (currentPubkey == null) {
        throw const CurrentUserNotFoundException();
      }
      pubkeysToFetch = [currentPubkey, ...pubkeysToFetch];
    }

    return pubkeysToFetch.toList();
  }

  Map<String, UserPagination> _initPagination({required List<String> pubkeys}) {
    final newPagination = <String, UserPagination>{};
    for (final pubkey in pubkeys) {
      newPagination[pubkey] = _getPubkeyPagination(pubkey);
    }
    return newPagination;
  }

  UserPagination _getPubkeyPagination(String pubkey) {
    return state.pagination[pubkey] ?? const UserPagination(page: -1, hasMore: true);
  }

  /// Returns a list of pubkeys that have the next page available.
  ///
  /// Priority is given to pubkeys with the lowest page number.
  Future<List<String>> _getNextPagePubkeys({
    required List<String> pubkeys,
    required int limit,
  }) async {
    int? minPage;
    final selected = <String>[];
    final remaining = <String>[];

    for (final pubkey in pubkeys) {
      final pagination = state.pagination[pubkey];

      if (pagination?.hasMore == false) continue;

      final page = pagination?.page ?? -1;

      if (page == minPage) {
        selected.add(pubkey);
      } else if (minPage == null || page < minPage) {
        // Found a lower page, reset the selection
        minPage = page;
        remaining.addAll(selected);
        selected
          ..clear()
          ..add(pubkey);
      } else {
        remaining.add(pubkey);
      }

      if (selected.length == limit) {
        return selected;
      }
    }

    if (selected.length < limit && remaining.isNotEmpty) {
      selected.addAll(
        await _getNextPagePubkeys(
          pubkeys: remaining,
          limit: limit - selected.length,
        ),
      );
    }

    return selected;
  }

  /// Fetch 1 entity for each provider pubkey and update the state with the results.
  Future<List<IonConnectEntity?>> _fetchEntities({
    required List<String> pubkeys,
  }) async {
    final requestsQueue = await ref.read(feedRequestQueueProvider.future);

    return Future.wait([
      for (final pubkey in pubkeys)
        requestsQueue.add(() async {
          final entity = await _fetchEntity(pubkey: pubkey);
          await _handleFetchedEntity(pubkey, entity);
          return entity;
        }).catchError((Object? error) {
          Logger.error(
            error ?? '',
            message: 'Error fetching entities for pubkey: $pubkey',
          );
          return null;
        }),
    ]);
  }

  /// Fetches a single entity for the given pubkey.
  ///
  /// Fetches the most recent entity if pagination is empty or the next entity if not.
  Future<IonConnectEntity?> _fetchEntity({
    required String pubkey,
  }) async {
    final feedConfig = await ref.read(feedConfigProvider.future);
    final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);

    final UserPagination(:lastEvent) = _getPubkeyPagination(pubkey);
    final dataSource = _getDataSource(pubkey);

    final until = lastEvent != null ? lastEvent.createdAt - 1 : null;
    final since = DateTime.now().subtract(feedConfig.followingReqMaxAge).microsecondsSinceEpoch;

    final requestMessage = RequestMessage();
    for (final filter in dataSource.requestFilters) {
      requestMessage.addFilter(
        filter.copyWith(
          limit: () => 1,
          until: () => until,
          since: () => since,
        ),
      );
    }

    return ionConnectNotifier
        .requestEntities(
          requestMessage,
          actionSource: dataSource.actionSource,
        )
        .where(dataSource.entityFilter)
        .firstOrNull;
  }

  /// Handles the fetched entity:
  /// * Updates the provider state: items, pagination.
  /// * Updates the seen entities state.
  Future<void> _handleFetchedEntity(
    String pubkey,
    IonConnectEntity? entity,
  ) async {
    final pagination = _getPubkeyPagination(pubkey);
    final feedConfig = await ref.read(feedConfigProvider.future);
    final seenEventsRepository = ref.read(followingFeedSeenEventsRepositoryProvider);

    // If the entity is null, it means there are no more entities to fetch for this pubkey.
    if (entity == null) {
      state = state.copyWith(
        pagination: {...state.pagination, pubkey: pagination.copyWith(hasMore: false)},
      );
      return;
    }

    // Update the nextEventReference for the previous event (pagination.lastEvent).
    // This maintains the correct sequence of seen events.
    final lastEvent = pagination.lastEvent;
    if (lastEvent != null) {
      await seenEventsRepository.setNextEvent(
        eventReference: lastEvent.eventReference,
        nextEventReference: entity.toEventReference(),
        feedType: feedType,
        feedModifier: feedModifier,
      );
    }

    // Checking if the entity has already been seen.
    // If it has, looking for the seen sequence end.
    final seenSequenceEnd = await seenEventsRepository.getSeenSequenceEnd(
      eventReference: entity.toEventReference(),
      feedType: feedType,
      feedModifier: feedModifier,
    );

    if (seenSequenceEnd == null) {
      // If the entity is not seen, we save it as a new seen event,
      // insert it to the state and update the pagination.
      await seenEventsRepository.save(entity, feedType: feedType, feedModifier: feedModifier);
      state = state.copyWith(
        items: {...(state.items ?? {}), entity},
        pagination: {
          ...state.pagination,
          pubkey: pagination.copyWith(
            page: pagination.page + 1,
            hasMore: true,
            lastEvent: (eventReference: entity.toEventReference(), createdAt: entity.createdAt),
          ),
        },
      );
    } else {
      // If the entity is seen, we do not insert it to the state,
      // but we update the pagination with the seen sequence end.
      // This is to ensure that we do not fetch the same entity again
      // and skip all the seen events in between.
      final hasMore = seenSequenceEnd.createdAt.toDateTime
          .isAfter(DateTime.now().subtract(feedConfig.followingReqMaxAge));
      state = state.copyWith(
        pagination: {
          ...state.pagination,
          pubkey: pagination.copyWith(
            page: pagination.page + 1,
            hasMore: hasMore,
            lastEvent: (
              eventReference: seenSequenceEnd.eventReference,
              createdAt: seenSequenceEnd.createdAt
            ),
          ),
        },
      );
    }
  }

  EntitiesDataSource _getDataSource(String pubkey) {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      throw const CurrentUserNotFoundException();
    }

    final feedModifierFilter = feedModifier?.filter;

    return switch (feedType) {
      FeedType.post => buildPostsDataSource(
          actionSource: ActionSource.user(pubkey),
          authors: [pubkey],
          currentPubkey: currentPubkey,
          searchExtensions: feedModifierFilter?.search,
          tags: feedModifierFilter?.tags,
        ),
      FeedType.article => buildArticlesDataSource(
          actionSource: ActionSource.user(pubkey),
          authors: [pubkey],
          currentPubkey: currentPubkey,
          searchExtensions: feedModifierFilter?.search,
          tags: feedModifierFilter?.tags,
        ),
      FeedType.video => buildVideosDataSource(
          actionSource: ActionSource.user(pubkey),
          authors: [pubkey],
          currentPubkey: currentPubkey,
          searchExtensions: feedModifierFilter?.search,
          tags: feedModifierFilter?.tags,
        ),
      FeedType.story => buildStoriesDataSource(
          actionSource: ActionSource.user(pubkey),
          authors: [pubkey],
          currentPubkey: currentPubkey,
          searchExtensions: feedModifierFilter?.search,
          tags: feedModifierFilter?.tags,
        ),
    };
  }
}

@Freezed(equal: false)
class FeedFollowingContentState with _$FeedFollowingContentState {
  const factory FeedFollowingContentState({
    required Set<IonConnectEntity>? items,
    required Map<String, UserPagination> pagination,
  }) = _FeedFollowingContentState;

  const FeedFollowingContentState._();

  bool get hasMore => pagination.values.any((pubkey) => pubkey.hasMore);
}

@Freezed(equal: false)
class UserPagination with _$UserPagination {
  const factory UserPagination({
    required int page,
    required bool hasMore,
    ({EventReference eventReference, int createdAt})? lastEvent,
  }) = _UserPagination;
}
