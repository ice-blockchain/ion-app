// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/followers_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_dao.c.g.dart';

@Riverpod(keepAlive: true)
FollowersDao followersDao(Ref ref) => FollowersDao(db: ref.watch(notificationsDatabaseProvider));

@DriftAccessor(tables: [FollowersTable])
class FollowersDao extends DatabaseAccessor<NotificationsDatabase> with _$FollowersDaoMixin {
  FollowersDao({required NotificationsDatabase db}) : super(db);

  Future<void> insert(Follower follower) async {
    await into(db.followersTable).insert(follower, mode: InsertMode.insertOrReplace);
  }

  Future<List<AggregatedFollowersResult>> getAggregated() {
    return db.aggregatedFollowers().get();
  }

  Future<DateTime?> getLastCreatedAt() async {
    final maxCreatedAt = followersTable.createdAt.max();
    return (selectOnly(followersTable)..addColumns([maxCreatedAt]))
        .map((row) => row.read(maxCreatedAt))
        .getSingleOrNull();
  }

  Stream<int> watchUnreadCount({required DateTime? after}) {
    final unreadCount = followersTable.pubkey.count();
    final query = selectOnly(followersTable)..addColumns([unreadCount]);

    if (after != null) {
      query.where(followersTable.createdAt.isBiggerThanValue(after));
    }

    return query.map((row) => row.read(unreadCount)!).watchSingle();
  }
}
