// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/dao/user_fetch_states_dao.m.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/data/models/user_fetch_state.dart';
import 'package:ion/app/features/feed/providers/relevant_users_to_fetch_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'following_users_fetch_states_repository.r.g.dart';

class FollowingUsersFetchStatesRepository implements UsersFetchStatesRepository {
  FollowingUsersFetchStatesRepository({
    required UserFetchStatesDao userFetchStatesDao,
  }) : _userFetchStatesDao = userFetchStatesDao;

  final UserFetchStatesDao _userFetchStatesDao;

  @override
  Future<void> save(
    String pubkey, {
    required FeedType feedType,
    required bool hasContent,
    FeedModifier? feedModifier,
  }) async {
    return _userFetchStatesDao.insertOrUpdate(
      pubkey,
      feedType: feedType,
      feedModifier: feedModifier,
      hasContent: hasContent,
    );
  }

  @override
  Future<List<UserFetchState>> select({
    required List<String> pubkeys,
    required FeedType feedType,
    FeedModifier? feedModifier,
  }) async {
    final savedStatesList = await _userFetchStatesDao.selectAll(
      pubkeys: pubkeys,
      feedType: feedType,
      feedModifier: feedModifier,
    );
    final savedStates = {
      for (final state in savedStatesList) state.pubkey: state,
    };
    return pubkeys.map((pubkey) {
      final savedState = savedStates[pubkey];
      if (savedState != null) {
        return UserFetchState(
          pubkey: pubkey,
          emptyFetchCount: savedState.emptyFetchCount,
          lastFetchTime: savedState.lastFetchTime.toDateTime,
          lastContentTime: savedState.lastContentTime?.toDateTime,
        );
      }
      return UserFetchState(pubkey: pubkey);
    }).toList();
  }
}

@Riverpod(keepAlive: true)
FollowingUsersFetchStatesRepository followingUsersFetchStatesRepository(Ref ref) =>
    FollowingUsersFetchStatesRepository(
      userFetchStatesDao: ref.watch(userFetchStatesDaoProvider),
    );
