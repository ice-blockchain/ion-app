import 'dart:async';

import 'package:async/async.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_config_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_data_source_builders.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_following_content_provider.c.freezed.dart';
part 'feed_following_content_provider.c.g.dart';

const _pageSize = 10;

@riverpod
class FeedFollowingContent extends _$FeedFollowingContent {
  @override
  FeedFollowingContentState build() {
    Future(fetch);
    return const FeedFollowingContentState(
      items: [],
      pagination: {},
    );
  }

  Future<void> fetch({int limit = _pageSize}) async {
    final followList = await ref.read(currentUserFollowListProvider.future);

    if (followList == null) {
      throw FollowListNotFoundException();
    }

    final pubkeys = await _getNextPagePubkeys(pubkeys: followList.pubkeys, limit: limit);

    if (pubkeys.isNotEmpty) {
      var fetchedEntities = 0;
      final entitiesStream = _fetchEntities(pubkeys: pubkeys);
      // pass until, since
      await for (final MapEntry(key: pubkey, value: entity) in entitiesStream) {
        if (entity != null) {
          fetchedEntities++;
        }
        //TODO: put entities in db, handle seen sequences
        final hasMore = entity != null; // TODO: not only this
        final pagination = _getPubkeyPagination(pubkey);
        state = state.copyWith(
          items: entity != null ? [...state.items, entity] : state.items,
          pagination: {
            ...state.pagination,
            pubkey: pagination.copyWith(
              page: pagination.page + 1,
              hasMore: hasMore,
              lastEventCreatedAt: entity?.createdAt,
            ),
          },
        );
      }
      if (fetchedEntities < limit) {
        return fetch(limit: limit - fetchedEntities);
      }
    }
  }

  UserPagination _getPubkeyPagination(String pubkey) {
    return state.pagination[pubkey] ?? const UserPagination(page: -1, hasMore: true);
  }

  Future<List<String>> _getNextPagePubkeys({
    required List<String> pubkeys,
    required int limit,
  }) async {
    int? currentPage;
    final result = <String>[];
    final candidates = <String>[];

    for (final pubkey in pubkeys) {
      final pagination = state.pagination[pubkey];

      if (pagination != null && !pagination.hasMore) {
        continue;
      }

      final page = pagination?.page ?? -1;

      if (page == currentPage) {
        result.add(pubkey);
      } else if (currentPage == null || page < currentPage) {
        currentPage = page;
        candidates.addAll(result);
        result
          ..clear()
          ..add(pubkey);
        if (result.length == limit) {
          return result;
        }
      } else {
        candidates.add(pubkey);
      }
    }

    if (result.length < limit && candidates.isNotEmpty) {
      result.addAll(
        await _getNextPagePubkeys(
          pubkeys: candidates,
          limit: limit - result.length,
        ),
      );
    }

    return result;
  }

  Stream<MapEntry<String, IonConnectEntity?>> _fetchEntities({
    required List<String> pubkeys,
  }) async* {
    final feedConfig = await ref.read(feedConfigProvider.future);
    final ionConnectNotifier = ref.read(ionConnectNotifierProvider.notifier);
    final currentPubkey = ref.read(currentPubkeySelectorProvider);

    if (currentPubkey == null) {
      throw const CurrentUserNotFoundException();
    }

    final since = DateTime.now().subtract(feedConfig.followingMaxAge).microsecondsSinceEpoch;

    // TODO:limit concurrent requests
    for (final pubkey in pubkeys) {
      try {
        final UserPagination(:lastEventCreatedAt) = _getPubkeyPagination(pubkey);
        final dataSource = buildPostsDataSource(
          actionSource: ActionSource.user(pubkey),
          authors: [pubkey],
          currentPubkey: currentPubkey,
        );

        final requestMessage = RequestMessage();
        for (final filter in dataSource.requestFilters) {
          requestMessage.addFilter(
            filter.copyWith(
              limit: () => 1,
              until: () => lastEventCreatedAt != null ? lastEventCreatedAt - 1 : null,
              since: () => since,
            ),
          );
        }

        final result = await ionConnectNotifier
            .requestEntities(
              requestMessage,
              actionSource: dataSource.actionSource,
            )
            .where((entity) => dataSource.entityFilter(entity) && !state.items.contains(entity))
            .firstOrNull;

        yield MapEntry(pubkey, result);
      } catch (error, stackTrace) {
        Logger.error(
          error,
          stackTrace: stackTrace,
          message: 'Error fetching entities for pubkey: $pubkey',
        );
      }
    }
  }
}

@Freezed(equal: false)
class FeedFollowingContentState with _$FeedFollowingContentState {
  const factory FeedFollowingContentState({
    required List<IonConnectEntity> items,
    required Map<String, UserPagination> pagination,
  }) = _FeedFollowingContentState;

  FeedFollowingContentState._();

  bool get hasMore => pagination.values.any((pubkey) => pubkey.hasMore);
}

@Freezed(equal: false)
class UserPagination with _$UserPagination {
  const factory UserPagination({
    required int page,
    required bool hasMore,
    int? lastEventCreatedAt,
  }) = _UserPagination;
}
