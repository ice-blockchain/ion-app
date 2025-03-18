// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/followers_table.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_dao.c.g.dart';

@Riverpod(keepAlive: true)
FollowersDao followersDao(Ref ref) => FollowersDao(db: ref.watch(notificationsDatabaseProvider));

@DriftAccessor(tables: [FollowersTable])
class FollowersDao extends DatabaseAccessor<NotificationsDatabase> with _$FollowersDaoMixin {
  FollowersDao({required NotificationsDatabase db}) : super(db);

  Future<void> insert(IonConnectEntity entity) async {
    await into(db.followersTable).insert(
      Follower(eventReference: entity.toEventReference(), createdAt: entity.createdAt),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<int?>> getCount() async {
    final count = followersTable.eventReference.count();
    final localTimezoneDay =
        followersTable.createdAt.modify(const DateTimeModifier.localTime()).day;
    final query = selectOnly(followersTable)
      ..addColumns([count])
      ..groupBy([localTimezoneDay])
      ..orderBy([OrderingTerm.asc(localTimezoneDay)]);

    return query.map((r) => r.read(count)).get();
  }

  // Future<List<AggregatedByDayRow>> getAggregatedByDay() {
  // return customSelect(getAggregatedByDayQuery(table: followersTable.actualTableName))
  //     .map(AggregatedByDayRow.fromQueryRow)
  //     .get();
  // }

  Future<DateTime?> getLastCreatedAt() async {
    final maxCreatedAt = followersTable.createdAt.max();
    return (selectOnly(followersTable)..addColumns([maxCreatedAt]))
        .map((row) => row.read(maxCreatedAt))
        .getSingleOrNull();
  }

  Stream<int> watchUnreadCount({required DateTime? after}) {
    final unreadCount = followersTable.eventReference.count();
    final query = selectOnly(followersTable)..addColumns([unreadCount]);

    if (after != null) {
      query.where(followersTable.createdAt.isBiggerThanValue(after));
    }

    return query.map((row) => row.read(unreadCount)!).watchSingle();
  }
}
