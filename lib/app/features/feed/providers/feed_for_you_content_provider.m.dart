// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/feed_config.f.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/data/models/retry_counter.dart';
import 'package:ion/app/features/feed/providers/feed_config_provider.r.dart';
import 'package:ion/app/features/feed/providers/feed_data_source_builders.dart';
import 'package:ion/app/features/feed/providers/feed_following_content_provider.m.dart';
import 'package:ion/app/features/feed/providers/feed_request_queue.r.dart';
import 'package:ion/app/features/feed/providers/feed_selected_article_categories_provider.r.dart';
import 'package:ion/app/features/feed/providers/feed_user_interest_picker_provider.r.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.r.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.f.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:ion/app/features/user/providers/relevant_current_user_relays_provider.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/utils/functions.dart';
import 'package:ion/app/utils/pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_for_you_content_provider.m.freezed.dart';
part 'feed_for_you_content_provider.m.g.dart';

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
      forYouRetryLimitReached: false,
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
    Logger.info('$_logTag Requesting events');

    var unseenFollowing = 0;
    final followingDistribution = _getFeedFollowingDistribution(limit: limit);

    await for (final entity in _fetchUnseenFollowing(limit: followingDistribution)) {
      yield entity;
      unseenFollowing++;
    }

    Logger.info('$_logTag Got [$unseenFollowing] unseen following events');

    if (unseenFollowing < limit) {
      yield* _fetchForYou(limit: limit - unseenFollowing);
    }

    Logger.info('$_logTag Done requesting events');
  }

  Stream<IonConnectEntity> _fetchForYou({required int limit}) async* {
    if (state.forYouRetryLimitReached) return;

    Logger.info('$_logTag Requesting [$limit] interested events');

    final retryCounter = await _buildRetryCounter();
    final modifiersDistribution = _getFeedModifiersDistribution(limit: limit);

    for (final MapEntry(key: modifier, value: modifierLimit) in modifiersDistribution.entries) {
      if (modifierLimit > 0) {
        yield* _fetchInterestsEntities(
          modifier: modifier,
          limit: modifierLimit,
          retryCounter: retryCounter,
        );
      }
    }

    if (retryCounter.isReached) {
      state = state.copyWith(forYouRetryLimitReached: true);
      Logger.warning('$_logTag Retry limit reached');
    }
  }

  Future<RetryCounter> _buildRetryCounter() async {
    final feedConfig = await ref.read(feedConfigProvider.future);
    final maxRetries = (feedType.pageSize * feedConfig.followingMaxRetriesMultiplier).ceil();
    return RetryCounter(limit: maxRetries);
  }

  int _getFeedFollowingDistribution({required int limit}) {
    return switch (feedType) {
      FeedType.post || FeedType.video || FeedType.article => (0.7 * limit).ceil(),
      FeedType.story => limit,
    };
  }

  Map<FeedModifier, int> _getFeedModifiersDistribution({required int limit}) {
    final modifierWeights =
        // If the "global" feed modifier is "trending", distribute to the
        // trending and explore modifiers equally (explore also has the "trending" search ext).
        feedModifier == FeedModifier.trending
            ? {
                FeedModifier.explore: 1,
                FeedModifier.trending: 1,
              }
            : switch (feedType) {
                // Regular feeds has equal distribution of all modifiers.
                FeedType.post || FeedType.video || FeedType.article => {
                    FeedModifier.explore: 1,
                    FeedModifier.top: 1,
                    FeedModifier.trending: 1,
                  },
                // Stories feed has only explore and trending modifiers.
                FeedType.story => {
                    FeedModifier.explore: 1,
                    FeedModifier.trending: 1,
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
    Logger.info('$_logTag Requesting [$limit] unseen following events');

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
    required FeedModifier modifier,
    required int limit,
    required RetryCounter retryCounter,
  }) async* {
    if (retryCounter.isReached) return;

    Logger.info('$_logTag Requesting [$limit] events with [${modifier.name}] modifier');

    await _refreshModifierPagination(modifier: modifier);

    final nextPageRelays =
        getNextPageSources(sources: state.modifiersPagination[modifier]!, limit: limit);

    Logger.info(
      nextPageRelays.isEmpty
          ? '$_logTag No sources for the next page of events with [${modifier.name}] modifier'
          : '$_logTag Next page sources are [${nextPageRelays.entries.length}] relays: ${nextPageRelays.keys} with [${modifier.name}] modifier',
    );

    if (nextPageRelays.isEmpty) return;

    var requestedCount = 0;
    await for (final entity in _requestEntitiesFromRelays(
      relays: nextPageRelays.keys,
      modifier: modifier,
      retryCounter: retryCounter,
    )) {
      yield entity;
      requestedCount++;
    }

    final remaining = limit - requestedCount;

    Logger.info(
      '$_logTag Got [$requestedCount] events with [${modifier.name}] modifier, remaining: [$remaining], tries left: [${retryCounter.triesLeft}]',
    );

    if (remaining > 0) {
      yield* _fetchInterestsEntities(
        modifier: modifier,
        limit: remaining,
        retryCounter: retryCounter,
      );
    }
  }

  Future<List<String>> _getDataSourceRelays() {
    return ref.read(relevantCurrentUserRelaysProvider.future);
  }

  Future<void> _refreshModifierPagination({required FeedModifier modifier}) async {
    // For any other feed type except articles, pagination can't be changed.
    // For Articles, user can select or unselect some topics, so we need to refresh the pagination
    if (feedType != FeedType.article && state.modifiersPagination[modifier] != null) return;

    final dataSourceRelays = await _getDataSourceRelays();

    final interests = await _getInterestsForModifier(modifier);

    final relaysPagination = Map.fromEntries(
      dataSourceRelays.map(
        (relayUrl) {
          final relayPagination = state.modifiersPagination[modifier]?[relayUrl] ??
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
        modifier: relaysPagination,
      },
    );
  }

  Stream<IonConnectEntity> _requestEntitiesFromRelays({
    required Iterable<String> relays,
    required FeedModifier modifier,
    required RetryCounter retryCounter,
  }) async* {
    final requestsQueue = await ref.read(feedRequestQueueProvider.future);
    final resultsController = StreamController<IonConnectEntity>();

    final requests = [
      for (final relayUrl in relays)
        requestsQueue.add(() async {
          if (retryCounter.isReached) return;

          final relayInterestsPagination =
              state.modifiersPagination[modifier]![relayUrl]!.interestsPagination;

          final interest = await _getRequestInterest(relayUrl: relayUrl, modifier: modifier);

          if (interest == null) {
            throw NoAvailableInterests(relayUrl: relayUrl, modifier: modifier.name);
          }

          final interestPagination = relayInterestsPagination[interest]!;

          final entity = await _requestEntityFromRelay(
            relayUrl: relayUrl,
            modifier: modifier,
            interest: interest,
            lastEventCreatedAt: interestPagination.lastEventCreatedAt,
          );

          if (entity != null) {
            if (_shouldShowEntity(entity)) {
              resultsController.add(entity);
            }
            // Even when we don't add an entity to the results (to not count this entity as "fetched"),
            // we still need update the pagination to shift the [lastEventCreatedAt].
            state = state.copyWithRelayInterestPagination(
              interestPagination.copyWith(lastEventCreatedAt: entity.createdAt),
              relayUrl: relayUrl,
              modifier: modifier,
              interest: interest,
              increasePage: true,
            );
          } else {
            Logger.info(
              '$_logTag No events found for interest: $interest, ${modifier.name}, on relay: $relayUrl, tries left ${retryCounter.triesLeft}',
            );
            retryCounter.increment();
            state = state.copyWithRelayInterestPagination(
              interestPagination.copyWith(hasMore: false),
              relayUrl: relayUrl,
              modifier: modifier,
              interest: interest,
            );
          }
        }).catchError((Object? error) {
          state = state.copyWithRelayPagination(
            state.modifiersPagination[modifier]![relayUrl]!.copyWith(hasMore: false),
            relayUrl: relayUrl,
            modifier: modifier,
          );
          Logger.error(
            error ?? '',
            message:
                '$_logTag Error requesting events with modifier: ${modifier.name}, on relay: $relayUrl',
          );
        }),
    ];

    unawaited(Future.wait(requests).whenComplete(resultsController.close));

    yield* resultsController.stream;
  }

  bool _shouldShowEntity(IonConnectEntity entity) {
    final currentItems = state.items ?? {};

    // The entity might have already been added to the state by another request.
    // For example, the entity might have been added through another modifier,
    // or it shares several topics and was already included to the state by a previous
    // request for a different interest.
    if (currentItems.contains(entity)) {
      Logger.info('$_logTag Entity already exists in the state, skipping: ${entity.id}');
      return false;
    }

    // For stories we fetch only one event per author.
    // The rest of the stories from the user are fetched on entering the full screen story view.
    if (feedType == FeedType.story &&
        currentItems.any((item) => item.masterPubkey == entity.masterPubkey)) {
      Logger.info(
        '$_logTag Story from the same author already exists in the state, skipping: ${entity.id}',
      );
      return false;
    }

    return true;
  }

  Future<String?> _getRequestInterest({
    required String relayUrl,
    required FeedModifier modifier,
  }) async {
    final relayInterestsPagination =
        state.modifiersPagination[modifier]![relayUrl]!.interestsPagination;

    // Pick from interests that still have more pages
    final availableInterests = relayInterestsPagination.entries
        .where((entry) => entry.value.hasMore)
        .map((entry) => entry.key)
        .toList();

    if (availableInterests.length == 1) {
      return availableInterests.first;
    }

    // For multiple interests, use the picker to select from available ones
    final interestsPicker = await ref.read(feedUserInterestPickerProvider(feedType).future);

    return interestsPicker.roll(availableInterests);
  }

  Future<IonConnectEntity?> _requestEntityFromRelay({
    required String relayUrl,
    required FeedModifier modifier,
    required String interest,
    required int? lastEventCreatedAt,
  }) async {
    final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);
    final feedConfig = await ref.read(feedConfigProvider.future);

    final dataSource = _getDataSource(
      relayUrl: relayUrl,
      modifier: modifier,
      interest: interest,
      feedConfig: feedConfig,
    );

    final maxAge = switch (modifier) {
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

    final entities = await ionConnectNotifier
        .requestEntities(requestMessage, actionSource: dataSource.actionSource)
        .toList();

    // TODO: Create a separate data source model that handles it internally
    if (dataSource.responseFilter != null) {
      return dataSource.responseFilter!.call(entities).firstOrNull;
    } else {
      return entities.firstWhereOrNull(dataSource.entityFilter);
    }
  }

  EntitiesDataSource _getDataSource({
    required String relayUrl,
    required FeedModifier modifier,
    required String interest,
    required FeedConfig feedConfig,
  }) {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      throw const CurrentUserNotFoundException();
    }

    final feedFilterFactory = FeedFilterFactory(feedConfig: feedConfig);
    // For explore feed, we use a special interest that is not related to any user interests.
    // It is defined in the [modifier] filter tags
    final tags = {
      ...feedFilterFactory.create(modifier).tags,
      if (modifier != FeedModifier.explore) '#${RelatedHashtag.tagName}': [interest],
    };

    // Global [feedModifier] has priority over the local [modifier].
    // This is for the "Trending Videos" case, where we have to apply the
    // "trending" modifier even to the "explore" [modifier].
    final modifiersSearch = feedFilterFactory.create(feedModifier ?? modifier).search;

    return switch (feedType) {
      FeedType.post => buildPostsDataSource(
          actionSource: ActionSource.relayUrl(relayUrl),
          currentPubkey: currentPubkey,
          searchExtensions: modifiersSearch,
          tags: tags,
        ),
      FeedType.article => buildArticlesDataSource(
          actionSource: ActionSource.relayUrl(relayUrl),
          currentPubkey: currentPubkey,
          searchExtensions: modifiersSearch,
          tags: tags,
        ),
      FeedType.video => buildVideosDataSource(
          actionSource: ActionSource.relayUrl(relayUrl),
          currentPubkey: currentPubkey,
          searchExtensions: modifiersSearch,
          tags: tags,
        ),
      FeedType.story => buildStoriesDataSource(
          actionSource: ActionSource.relayUrl(relayUrl),
          currentPubkey: currentPubkey,
          searchExtensions: modifiersSearch,
          tags: tags,
        ),
    };
  }

  void _ensureEmptyState() {
    if (state.items == null) {
      state = state.copyWith(items: const {});
    }
  }

  /// Determines which interests should be used for the given modifier and feed type.
  Future<List<String>> _getInterestsForModifier(FeedModifier modifier) async {
    if (modifier == FeedModifier.explore) {
      return [_exploreInterest];
    }

    if (feedType == FeedType.article) {
      final selectedArticleCategories = ref.read(feedSelectedArticleCategoriesProvider);
      return selectedArticleCategories.isEmpty
          ? [_exploreInterest]
          : selectedArticleCategories.toList();
    }

    final userInterests = await ref.read(feedUserInterestsProvider(feedType).future);
    return userInterests.categories.keys.toList();
  }

  String get _logTag => '[FEED FOR_YOU ${feedType.name}]';

  static final String _exploreInterest = '_${FeedModifier.explore}';
}

@Freezed(equal: false)
class FeedForYouContentState with _$FeedForYouContentState implements PagedState {
  const factory FeedForYouContentState({
    required Set<IonConnectEntity>? items,
    required Map<FeedModifier, Map<String, RelayPagination>> modifiersPagination,
    required bool forYouRetryLimitReached,
    required bool hasMoreFollowing,
    required bool isLoading,
  }) = _FeedForYouContentState;

  const FeedForYouContentState._();

  bool get hasMoreForYou => modifiersPagination.values.any(
        (modifierPagination) => modifierPagination.values.any((pagination) => pagination.hasMore),
      );

  FeedForYouContentState copyWithRelayPagination(
    RelayPagination pagination, {
    required String relayUrl,
    required FeedModifier modifier,
  }) {
    return copyWith(
      modifiersPagination: {
        ...modifiersPagination,
        modifier: {
          ...modifiersPagination[modifier]!,
          relayUrl: pagination,
        },
      },
    );
  }

  FeedForYouContentState copyWithRelayInterestPagination(
    InterestPagination pagination, {
    required String relayUrl,
    required FeedModifier modifier,
    required String interest,
    bool increasePage = false,
  }) {
    final relayPagination = modifiersPagination[modifier]![relayUrl]!;
    final interestsPagination = {
      ...relayPagination.interestsPagination,
      interest: pagination,
    };
    return copyWithRelayPagination(
      relayPagination.copyWith(
        interestsPagination: interestsPagination,
        page: relayPagination.page + (increasePage ? 1 : 0),
        hasMore: interestsPagination.values.any((pagination) => pagination.hasMore),
      ),
      relayUrl: relayUrl,
      modifier: modifier,
    );
  }

  @override
  bool get hasMore => hasMoreFollowing || (hasMoreForYou && !forYouRetryLimitReached);
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
