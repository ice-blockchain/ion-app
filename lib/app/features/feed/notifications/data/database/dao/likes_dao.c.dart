// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/likes_table.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_dao.c.g.dart';

@Riverpod(keepAlive: true)
LikesDao likesDao(Ref ref) => LikesDao(db: ref.watch(notificationsDatabaseProvider));

@DriftAccessor(tables: [LikesTable])
class LikesDao extends DatabaseAccessor<NotificationsDatabase> with _$LikesDaoMixin {
  LikesDao({required NotificationsDatabase db}) : super(db);

  Future<void> insert(IonConnectEntity entity) async {
    await into(db.likesTable).insert(
      Like(eventReference: entity.toEventReference(), createdAt: entity.createdAt),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<String>> getAggregatedByDay() {
    return customSelect('''
      WITH RankedRows AS (
          SELECT
              *,
              DATE(datetime(created_at, 'unixepoch', 'localtime')) AS LocalDay,
              ROW_NUMBER() OVER (PARTITION BY DATE(datetime(created_at, 'unixepoch', 'localtime')) ORDER BY created_at DESC) AS RowNum
          FROM 
              likes_table
      ),
      DailyCounts AS (
          SELECT 
              LocalDay AS Day, 
              COUNT(*) AS NumberOfRows
          FROM 
              RankedRows
          GROUP BY 
              LocalDay
      )
      SELECT 
          r.LocalDay AS Day,
          GROUP_CONCAT(r.event_reference, ', ' ORDER BY r.created_at DESC) AS ConcatenatedResults,
          d.NumberOfRows
      FROM 
          RankedRows r
      JOIN 
          DailyCounts d ON r.LocalDay = d.Day
      WHERE 
          r.RowNum <= 4
      GROUP BY 
          r.LocalDay
      ORDER BY 
          r.created_at DESC;
    ''').map((row) {
      final foo = row.read<String>('Day');
      // print(DateTime.fromMillisecondsSinceEpoch(foo));
      return foo;
    }).get();
  }

  Future<DateTime?> getLastCreatedAt() async {
    final maxCreatedAt = likesTable.createdAt.max();
    return (selectOnly(likesTable)..addColumns([maxCreatedAt]))
        .map((row) => row.read(maxCreatedAt))
        .getSingleOrNull();
  }

  Stream<int> watchUnreadCount({required DateTime? after}) {
    final unreadCount = likesTable.eventReference.count();
    final query = selectOnly(likesTable)..addColumns([unreadCount]);

    if (after != null) {
      query.where(likesTable.createdAt.isBiggerThanValue(after));
    }

    return query.map((row) => row.read(unreadCount)!).watchSingle();
  }
}
