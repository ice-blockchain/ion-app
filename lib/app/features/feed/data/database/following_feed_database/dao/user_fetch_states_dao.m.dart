// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.m.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/tables/user_fetch_states_table.d.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_fetch_states_dao.m.g.dart';

@DriftAccessor(tables: [UserFetchStatesTable])
class UserFetchStatesDao extends DatabaseAccessor<FollowingFeedDatabase>
    with _$UserFetchStatesDaoMixin {
  UserFetchStatesDao({required FollowingFeedDatabase db}) : super(db);

  Future<void> insertOrUpdate(
    String pubkey, {
    required FeedType feedType,
    required bool hasContent,
    FeedModifier? feedModifier,
  }) async {
    await into(userFetchStatesTable).insert(
      UserFetchStatesTableCompanion.insert(
        feedType: feedType,
        feedModifier: Value(feedModifier),
        pubkey: pubkey,
        emptyFetchCount: hasContent ? 0 : 1,
        lastFetchTime: DateTime.now().microsecondsSinceEpoch,
        lastContentTime: Value(hasContent ? DateTime.now().microsecondsSinceEpoch : null),
      ),
      onConflict: DoUpdate(
        (old) => UserFetchStatesTableCompanion.custom(
          feedType: old.feedType,
          feedModifier: old.feedModifier,
          pubkey: old.pubkey,
          emptyFetchCount: hasContent ? const Constant(0) : old.emptyFetchCount + const Constant(1),
          lastFetchTime: Constant(DateTime.now().microsecondsSinceEpoch),
          lastContentTime: hasContent ? Constant(DateTime.now().microsecondsSinceEpoch) : null,
        ),
      ),
    );
  }

  Future<List<FollowingUserFetchState>> selectAll({
    required List<String> pubkeys,
    required FeedType feedType,
    FeedModifier? feedModifier,
  }) {
    final query = select(userFetchStatesTable)
      ..where((tbl) => tbl.pubkey.isIn(pubkeys))
      ..where((tbl) => tbl.feedType.equalsValue(feedType))
      ..where(
        (tbl) => feedModifier == null
            ? tbl.feedModifier.isNull()
            : tbl.feedModifier.equalsValue(feedModifier),
      );
    return query.get();
  }
}

@Riverpod(keepAlive: true)
UserFetchStatesDao userFetchStatesDao(Ref ref) =>
    UserFetchStatesDao(db: ref.watch(followingFeedDatabaseProvider));
