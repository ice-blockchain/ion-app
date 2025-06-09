// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:async/async.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
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
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_following_content_provider.c.freezed.dart';
part 'feed_following_content_provider.c.g.dart';

@riverpod
class FeedFollowingContent extends _$FeedFollowingContent implements PagedNotifier {
  @override
  FeedFollowingContentState build(
    FeedType feedType, {
    FeedModifier? feedModifier,
    bool showSeen = true,
  }) {
    Future.microtask(fetchEntities);
    return FeedFollowingContentState(
      items: null,
      isLoading: false,
      seenPagination: Pagination(page: -1, hasMore: showSeen),
      unseenPagination: {},
    );
  }

  /// Fetches entities for the feed:
  /// * First, requests unseen entities from followed users (see [_fetchUnseenEntities]).
  /// * Then, if [showSeen] is true, requests seen entities (see [_fetchSeenEntities]).
  @override
  Future<void> fetchEntities({int? limit}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      final fetchLimit = limit ?? feedType.pageSize;
      var remaining = await _fetchUnseenEntities(limit: fetchLimit);
      if (remaining > 0 && showSeen) {
        remaining = await _fetchSeenEntities(limit: remaining);
      }
      if (remaining == fetchLimit) {
        _ensureEmptyState();
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
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

  /// Fetches unseen entities up to the specified [limit].
  ///
  /// This method recursively fetches entities from the followed pubkeys until the limit is reached
  /// or no more unseen entities are available.
  ///
  /// Returns the number of unseen entities that could not be fetched (0 if all were fetched).
  Future<int> _fetchUnseenEntities({required int limit}) async {
    final dataSourcePubkeys = await _getDataSourcePubkeys();
    if (dataSourcePubkeys.isEmpty) return limit;

    _initPagination(pubkeys: dataSourcePubkeys);

    final nextPagePubkeys = await _getNextPagePubkeys(pubkeys: dataSourcePubkeys, limit: limit);

    if (nextPagePubkeys.isEmpty) return limit;

    final results = await _requestEntitiesFromPubkeys(pubkeys: nextPagePubkeys);
    final remaining = limit - results.nonNulls.length;

    if (remaining > 0) {
      return _fetchUnseenEntities(limit: remaining);
    }

    return remaining;
  }

  /// Fetches seen entities up to the specified [limit].
  ///
  /// This method retrieves entities that have been seen by the user,
  /// excluding those already present in the current state.
  ///
  /// Returns the number of seen entities that could not be fetched (0 if all were fetched).
  Future<int> _fetchSeenEntities({required int limit}) async {
    final seenEventsRepository = ref.read(followingFeedSeenEventsRepositoryProvider);
    final feedConfig = await ref.read(feedConfigProvider.future);

    final stateEntityReferences =
        state.items?.map((entity) => entity.toEventReference()).toList() ?? [];
    final seenEvents = await seenEventsRepository.getEventReferences(
      feedType: feedType,
      feedModifier: feedModifier,
      exclude: stateEntityReferences,
      limit: limit,
      since: DateTime.now().subtract(feedConfig.followingCacheMaxAge).microsecondsSinceEpoch,
      until: state.seenPagination.lastEvent?.createdAt,
    );

    state = state.copyWith(
      seenPagination: state.seenPagination.copyWith(
        hasMore: seenEvents.isNotEmpty,
        lastEvent: seenEvents.lastOrNull,
      ),
    );

    if (seenEvents.isEmpty) {
      return limit;
    }

    final results = await _requestEntitiesByReferences(
      eventReferences: seenEvents.map((event) => event.eventReference).toList(),
    );
    final remaining = limit - results.nonNulls.length;

    if (remaining > 0) {
      return _fetchSeenEntities(limit: remaining);
    }

    return remaining;
  }

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

    var dataSourcePubkeys = followList.data.list.map((followee) => followee.pubkey);

    // In case of stories - we also need to request own entities
    if (feedType == FeedType.story) {
      final currentPubkey = ref.read(currentPubkeySelectorProvider);
      if (currentPubkey == null) {
        throw const CurrentUserNotFoundException();
      }
      dataSourcePubkeys = [currentPubkey, ...dataSourcePubkeys];
    }

    return dataSourcePubkeys.toList();
  }

  void _initPagination({required List<String> pubkeys}) {
    final newPagination = {
      for (final pubkey in pubkeys) pubkey: _getPubkeyPagination(pubkey),
    };
    state = state.copyWith(unseenPagination: newPagination);
  }

  Pagination _getPubkeyPagination(String pubkey) {
    return state.unseenPagination[pubkey] ?? const Pagination(page: -1, hasMore: true);
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
      final pagination = state.unseenPagination[pubkey];

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

  /// Request 1 entity for each provider pubkey and update the state with the results.
  Future<List<IonConnectEntity?>> _requestEntitiesFromPubkeys({
    required List<String> pubkeys,
  }) async {
    final requestsQueue = await ref.read(feedRequestQueueProvider.future);

    return Future.wait([
      for (final pubkey in pubkeys)
        requestsQueue.add(() async {
          final Pagination(:lastEvent) = _getPubkeyPagination(pubkey);
          final entity = await _requestEntityFromPubkey(
            pubkey: pubkey,
            lastEventCreatedAt: lastEvent?.createdAt,
          );
          final valid = await _handleRequestedPubkeyEntity(
            pubkey: pubkey,
            entity: entity,
            lastEventReference: lastEvent?.eventReference,
          );
          return valid ? entity : null;
        }).catchError((Object? error) {
          Logger.error(
            error ?? '',
            message: 'Error requesting entities for pubkey: $pubkey',
          );
          return null;
        }),
    ]);
  }

  /// Requests a single entity for the given pubkey.
  ///
  /// Requests the most recent entity if pagination is empty or the next entity if not.
  Future<IonConnectEntity?> _requestEntityFromPubkey({
    required String pubkey,
    required int? lastEventCreatedAt,
  }) async {
    final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);

    final dataSource = _getDataSourceForPubkey(pubkey);

    final until = lastEventCreatedAt != null ? lastEventCreatedAt - 1 : null;
    final requestMessage = RequestMessage();
    for (final filter in dataSource.requestFilters) {
      requestMessage.addFilter(
        // Do not use `since` here (from feedConfig.followingReqMaxAge),
        // as we want to request one overflow entity (if it exists),
        // to avoid the unnecessary requests in the future.
        filter.copyWith(
          limit: () => 1,
          until: () => until,
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

  Future<List<IonConnectEntity?>> _requestEntitiesByReferences({
    required List<EventReference> eventReferences,
  }) async {
    final requestsQueue = await ref.read(feedRequestQueueProvider.future);

    return Future.wait([
      for (final eventReference in eventReferences)
        requestsQueue.add(() async {
          final entity = await _requestEntityByReference(eventReference: eventReference);
          final valid =
              await _handleRequestedReferenceEntity(eventReference: eventReference, entity: entity);
          return valid ? entity : null;
        }).catchError((Object? error) {
          Logger.error(
            error ?? '',
            message: 'Error requesting entities for event reference: $eventReference',
          );
          return null;
        }),
    ]);
  }

  Future<IonConnectEntity?> _requestEntityByReference({
    required EventReference eventReference,
  }) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentPubkey == null) {
      throw const CurrentUserNotFoundException();
    }

    final kind =
        eventReference is ReplaceableEventReference ? eventReference.kind : PostEntity.kind;

    final search = SearchExtensions([
      ...SearchExtensions.withCounters(currentPubkey: currentPubkey, forKind: kind).extensions,
      ...SearchExtensions.withAuthors(forKind: kind).extensions,
    ]).toString();

    return ref
        .read(ionConnectEntityProvider(eventReference: eventReference, search: search).future);
  }

  /// Handles the requested entity:
  /// * Updates the provider state: items, pagination.
  /// * Updates the seen entities state
  ///
  /// returns `true` if the entity is in the required time frame
  Future<bool> _handleRequestedPubkeyEntity({
    required String pubkey,
    required IonConnectEntity? entity,
    required EventReference? lastEventReference,
  }) async {
    final pagination = _getPubkeyPagination(pubkey);
    final seenEventsRepository = ref.read(followingFeedSeenEventsRepositoryProvider);

    // If the entity is null, it means there are no more entities to request for this pubkey.
    if (entity == null) {
      state = state.copyWith(
        unseenPagination: {...state.unseenPagination, pubkey: pagination.copyWith(hasMore: false)},
      );
      return false;
    }

    // Update the nextEventReference for the previous event (pagination.lastEvent).
    // This maintains the correct sequence of seen events.
    if (lastEventReference != null) {
      await seenEventsRepository.setNextEvent(
        eventReference: lastEventReference,
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
      // update the state items and pagination.
      await seenEventsRepository.save(entity, feedType: feedType, feedModifier: feedModifier);
      // TODO:add repost deduplication here
      final isInReqTimeFrame = await _isInReqTimeFrame(entity.createdAt);
      state = state.copyWith(
        items: isInReqTimeFrame ? {...(state.items ?? {}), entity} : state.items,
        unseenPagination: {
          ...state.unseenPagination,
          pubkey: pagination.copyWith(
            page: pagination.page + 1,
            hasMore: isInReqTimeFrame,
            lastEvent: (
              eventReference: entity.toEventReference(),
              createdAt: entity.createdAt,
            ),
          ),
        },
      );
      return isInReqTimeFrame;
    } else {
      // If the entity is seen, we do not insert it to the state,
      // but we update the pagination with the seen sequence end.
      // This is to ensure that we do not request the same entity again
      // and skip all the seen events in between.
      final isInReqTimeFrame = await _isInReqTimeFrame(seenSequenceEnd.createdAt);
      state = state.copyWith(
        unseenPagination: {
          ...state.unseenPagination,
          pubkey: pagination.copyWith(
            page: pagination.page + 1,
            hasMore: isInReqTimeFrame,
            lastEvent: (
              eventReference: seenSequenceEnd.eventReference,
              createdAt: seenSequenceEnd.createdAt
            ),
          ),
        },
      );
      return false;
    }
  }

  Future<bool> _handleRequestedReferenceEntity({
    required EventReference eventReference,
    required IonConnectEntity? entity,
  }) async {
    if (entity == null) return false;
    // TODO:add repost deduplication here
    state = state.copyWith(items: {...(state.items ?? {}), entity});
    return true;
  }

  EntitiesDataSource _getDataSourceForPubkey(String pubkey) {
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

  Future<bool> _isInReqTimeFrame(int time) async {
    final feedConfig = await ref.read(feedConfigProvider.future);
    return time.toDateTime.isAfter(DateTime.now().subtract(feedConfig.followingReqMaxAge));
  }
}

@Freezed(equal: false)
class FeedFollowingContentState with _$FeedFollowingContentState {
  const factory FeedFollowingContentState({
    required Set<IonConnectEntity>? items,
    required Map<String, Pagination> unseenPagination,
    required Pagination seenPagination,
    required bool isLoading,
  }) = _FeedFollowingContentState;

  const FeedFollowingContentState._();

  bool get hasMore =>
      unseenPagination.values.any((pubkey) => pubkey.hasMore) || seenPagination.hasMore;
}

@Freezed(equal: false)
class Pagination with _$Pagination {
  const factory Pagination({
    required int page,
    required bool hasMore,
    ({EventReference eventReference, int createdAt})? lastEvent,
  }) = _Pagination;
}
