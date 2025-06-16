// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_config_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_data_source_builders.dart';
import 'package:ion/app/features/feed/providers/feed_following_content_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_request_queue.c.dart';
import 'package:ion/app/features/feed/providers/feed_user_interest_picker_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
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
      feedFollowingContentProvider(
        feedType,
        feedModifier: feedModifier,
        fetchSeen: false,
        autoFetch: false,
      ),
      noop,
    );
    return const FeedForYouContentState(
      items: null,
      isLoading: false,
      hasMoreFollowing: true,
      modifiersPagination: {},
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
    final followingDistribution = _getFeedFollowingDistribution(limit: limit);
    await for (final entity in _fetchUnseenFollowing(limit: followingDistribution)) {
      yield entity;
      unseenFollowing++;
    }
    if (unseenFollowing < limit) {
      final modifiersDistribution = _getFeedModifiersDistribution(limit: limit - unseenFollowing);
      for (final MapEntry(key: modifier, value: modifierLimit) in modifiersDistribution.entries) {
        if (modifierLimit > 0) {
          yield* _fetchInterestsEntities(feedModifier: modifier, limit: modifierLimit);
        }
      }
    }
  }

  int _getFeedFollowingDistribution({required int limit}) {
    return switch (feedType) {
      FeedType.post || FeedType.video || FeedType.article => (0.7 * limit).ceil(),
      FeedType.story => limit,
    };
  }

  Map<FeedModifier, int> _getFeedModifiersDistribution({required int limit}) {
    if (feedModifier != null) {
      // If a specific feed modifier is set, we only return that modifier with the full limit.
      // For example, for the Trending Videos feed.
      return {feedModifier!: limit};
    }

    final modifierWeights = switch (feedType) {
      FeedType.post || FeedType.video || FeedType.article => {
          FeedModifier.top: 1,
          FeedModifier.trending: 1,
          FeedModifier.explore: 1,
        },
      FeedType.story => {
          FeedModifier.trending: 1,
          FeedModifier.explore: 1,
        },
    };
    final totalWeight = modifierWeights.values.sum;
    return {
      for (final entry in modifierWeights.entries)
        entry.key: (limit * entry.value / totalWeight).ceil(),
    };
  }

  @override
  void refresh() {
    if (!state.isLoading) {
      ref
        ..invalidate(
          feedFollowingContentProvider(
            feedType,
            feedModifier: feedModifier,
            fetchSeen: false,
            autoFetch: false,
          ),
        )
        ..invalidateSelf();
    }
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

  Stream<IonConnectEntity> _fetchUnseenFollowing({required int limit}) async* {
    final notifier = ref.read(
      feedFollowingContentProvider(
        feedType,
        feedModifier: feedModifier,
        fetchSeen: false,
        autoFetch: false,
      ).notifier,
    );
    final provider = ref.read(
      feedFollowingContentProvider(
        feedType,
        feedModifier: feedModifier,
        fetchSeen: false,
        autoFetch: false,
      ),
    );

    if (!provider.hasMore) {
      state = state.copyWith(hasMoreFollowing: false);
      return;
    }

    yield* notifier.requestEntities(limit: limit);

    if (!provider.hasMore) {
      state = state.copyWith(hasMoreFollowing: false);
    }
  }

  Stream<IonConnectEntity> _fetchInterestsEntities({
    required FeedModifier feedModifier,
    required int limit,
  }) async* {
    await _refreshModifierPagination(feedModifier: feedModifier);

    final nextPageRelays =
        getNextPageSources(sources: state.modifiersPagination[feedModifier]!, limit: limit);

    if (nextPageRelays.isEmpty) return;

    var requestedCount = 0;
    await for (final entity
        in _requestEntitiesFromRelays(relays: nextPageRelays.keys, feedModifier: feedModifier)) {
      yield entity;
      requestedCount++;
    }

    final remaining = limit - requestedCount;

    if (remaining > 0) {
      yield* _fetchInterestsEntities(feedModifier: feedModifier, limit: remaining);
    }
  }

  Future<List<String>> _getDataSourceRelays() {
    return ref.read(relevantCurrentUserRelaysProvider.future);
  }

  Future<void> _refreshModifierPagination({required FeedModifier feedModifier}) async {
    // For any other feed type except articles, pagination can't be changed.
    // For Articles, user can select or unselect some topics, so we need to refresh the pagination
    if (feedType != FeedType.article && state.modifiersPagination[feedModifier] != null) return;

    final dataSourceRelays = await _getDataSourceRelays();

    // TODO: for articles (if feedType is FeedType.article), take the selected interests
    final interests =
        (await ref.read(feedUserInterestsProvider(feedType).future)).subcategories.keys;

    final relaysPagination = Map.fromEntries(
      dataSourceRelays.map(
        (relayUrl) {
          final relayPagination = state.modifiersPagination[feedModifier]?[relayUrl] ??
              const RelayPagination(page: -1, hasMore: true, interestsPagination: {});
          final interestsPagination = Map.fromEntries(
            interests.map(
              (interest) {
                return MapEntry(
                  interest,
                  relayPagination.interestsPagination[interest] ??
                      const InterestPagination(hasMore: true),
                );
              },
            ),
          );
          return MapEntry(
            relayUrl,
            relayPagination.copyWith(interestsPagination: interestsPagination),
          );
        },
      ),
    );

    state = state.copyWith(
      modifiersPagination: {
        ...state.modifiersPagination,
        feedModifier: relaysPagination,
      },
    );
  }

  Stream<IonConnectEntity> _requestEntitiesFromRelays({
    required Iterable<String> relays,
    required FeedModifier feedModifier,
  }) async* {
    final requestsQueue = await ref.read(feedRequestQueueProvider.future);
    final resultsController = StreamController<IonConnectEntity>();

    final requests = [
      for (final relayUrl in relays)
        requestsQueue.add(() async {
          final interestsPicker = await ref.read(feedUserInterestPickerProvider(feedType).future);

          final relayInterestsPagination =
              state.modifiersPagination[feedModifier]![relayUrl]!.interestsPagination;

          final availableInterests = relayInterestsPagination.entries
              .where((entry) => entry.value.hasMore)
              .map((entry) => entry.key)
              .toList();

          final interest = interestsPicker.roll(availableInterests)!;

          final interestPagination = relayInterestsPagination[interest]!;

          final entity = await _requestEntityFromRelay(
            relayUrl: relayUrl,
            feedModifier: feedModifier,
            interest: interest,
            lastEventCreatedAt: interestPagination.lastEventCreatedAt,
          );

          if (entity != null) {
            if (state.items?.contains(entity) != true) {
              // The entity might have already been added to the state by another request.
              // For example, the entity might have been added through another modifier,
              // or it shares several topics and was already included to the state by a previous
              // request for a different interest.
              // In this case we don't add it the results (to not count this entity as "fetched"),
              // but still update the pagination to shift the [lastEventCreatedAt].
              resultsController.add(entity);
            }
            _updateRelayInterestPagination(
              interestPagination.copyWith(lastEventCreatedAt: entity.createdAt),
              relayUrl: relayUrl,
              feedModifier: feedModifier,
              interest: interest,
              increasePage: true,
            );
          } else {
            _updateRelayInterestPagination(
              interestPagination.copyWith(hasMore: false),
              relayUrl: relayUrl,
              feedModifier: feedModifier,
              interest: interest,
            );
          }
        }).catchError((Object? error) {
          _updateRelayPagination(
            state.modifiersPagination[feedModifier]![relayUrl]!.copyWith(hasMore: false),
            relayUrl: relayUrl,
            feedModifier: feedModifier,
          );
          Logger.error(
            error ?? '',
            message: 'Error requesting entities from relay: $relayUrl',
          );
        }),
    ];

    unawaited(Future.wait(requests).whenComplete(resultsController.close));

    yield* resultsController.stream;
  }

  Future<IonConnectEntity?> _requestEntityFromRelay({
    required String relayUrl,
    required FeedModifier feedModifier,
    required String interest,
    required int? lastEventCreatedAt,
  }) async {
    final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);
    final feedConfig = await ref.read(feedConfigProvider.future);

    final dataSource =
        _getDataSource(relayUrl: relayUrl, feedModifier: feedModifier, interest: interest);

    final maxAge = switch (feedModifier) {
      FeedModifier.trending => feedConfig.trendingMaxAge,
      FeedModifier.top => feedConfig.topMaxAge,
      FeedModifier.explore => feedConfig.exploreMaxAge,
    };

    final since = DateTime.now().subtract(maxAge).microsecondsSinceEpoch;
    final until = lastEventCreatedAt != null ? lastEventCreatedAt - 1 : null;
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

  EntitiesDataSource _getDataSource({
    required String relayUrl,
    required FeedModifier feedModifier,
    required String interest,
  }) {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      throw const CurrentUserNotFoundException();
    }

    final tags = {
      ...feedModifier.filter.tags,
      '#${RelatedHashtag.tagName}': [interest],
    };

    return switch (feedType) {
      FeedType.post => buildPostsDataSource(
          actionSource: ActionSource.relayUrl(relayUrl),
          currentPubkey: currentPubkey,
          searchExtensions: feedModifier.filter.search,
          tags: tags,
        ),
      FeedType.article => buildArticlesDataSource(
          actionSource: ActionSource.relayUrl(relayUrl),
          currentPubkey: currentPubkey,
          searchExtensions: feedModifier.filter.search,
          tags: tags,
        ),
      FeedType.video => buildVideosDataSource(
          actionSource: ActionSource.relayUrl(relayUrl),
          currentPubkey: currentPubkey,
          searchExtensions: feedModifier.filter.search,
          tags: tags,
        ),
      FeedType.story => buildStoriesDataSource(
          actionSource: ActionSource.relayUrl(relayUrl),
          currentPubkey: currentPubkey,
          searchExtensions: feedModifier.filter.search,
          tags: tags,
        ),
    };
  }

  void _ensureEmptyState() {
    if (state.items == null) {
      state = state.copyWith(items: const {});
    }
  }

  void _updateRelayPagination(
    RelayPagination pagination, {
    required String relayUrl,
    required FeedModifier feedModifier,
    bool increasePage = false,
  }) {
    state = state.copyWith(
      modifiersPagination: {
        ...state.modifiersPagination,
        feedModifier: {
          ...state.modifiersPagination[feedModifier]!,
          relayUrl: pagination,
        },
      },
    );
  }

  void _updateRelayInterestPagination(
    InterestPagination pagination, {
    required String relayUrl,
    required FeedModifier feedModifier,
    required String interest,
    bool increasePage = false,
  }) {
    final relayPagination = state.modifiersPagination[feedModifier]![relayUrl]!;
    final interestsPagination = {
      ...relayPagination.interestsPagination,
      interest: pagination,
    };
    _updateRelayPagination(
      relayPagination.copyWith(
        interestsPagination: interestsPagination,
        page: relayPagination.page + (increasePage ? 1 : 0),
        hasMore: interestsPagination.values.any((interest) => interest.hasMore),
      ),
      relayUrl: relayUrl,
      feedModifier: feedModifier,
      increasePage: increasePage,
    );
  }
}

@Freezed(equal: false)
class FeedForYouContentState with _$FeedForYouContentState implements PagedState {
  const factory FeedForYouContentState({
    required Set<IonConnectEntity>? items,
    required Map<FeedModifier, Map<String, RelayPagination>> modifiersPagination,
    required bool hasMoreFollowing,
    required bool isLoading,
  }) = _FeedForYouContentState;

  const FeedForYouContentState._();

  @override
  bool get hasMore =>
      hasMoreFollowing ||
      modifiersPagination.values.any(
        (modifierPagination) => modifierPagination.values.any((pagination) => pagination.hasMore),
      );
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
