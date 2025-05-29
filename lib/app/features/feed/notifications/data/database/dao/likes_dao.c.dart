// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/database.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/likes_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_dao.c.g.dart';

@Riverpod(keepAlive: true)
LikesDao likesDao(Ref ref) => LikesDao(db: ref.watch(notificationsDatabaseProvider));

@DriftAccessor(tables: [LikesTable])
class LikesDao extends DatabaseAccessor<NotificationsDatabase> with _$LikesDaoMixin {
  LikesDao({required NotificationsDatabase db}) : super(db);

  Future<void> insert(Like like) async {
    await into(db.likesTable).insert(like, mode: InsertMode.insertOrReplace);
  }

  Future<List<AggregatedLikesResult>> getAggregated() {
    return db.aggregatedLikes().get();
  }

  Future<DateTime?> getLastCreatedAt() async {
    // final max = await maxTimestamp(
    //   likesTable,
    //   likesTable.actualTableName,
    //   likesTable.createdAt.name,
    // );
    // return max?.toDateTime;

    final maxCreatedAt = likesTable.normalizedTimestamp(likesTable.createdAt).max();
    final max = await (selectOnly(likesTable)..addColumns([maxCreatedAt]))
        .map((row) => row.read(maxCreatedAt))
        .getSingleOrNull();
    return max?.toDateTime;
  }

  Future<DateTime?> getFirstCreatedAt({DateTime? after}) async {
    // final min = await minTimestamp(
    //   likesTable,
    //   likesTable.actualTableName,
    //   likesTable.createdAt.name,
    //   afterTimestamp: after?.microsecondsSinceEpoch,
    // );
    // return min?.toDateTime;

    final firstCreatedAt = likesTable.normalizedTimestamp(likesTable.createdAt).min();
    final query = selectOnly(likesTable)..addColumns([firstCreatedAt]);
    if (after != null) {
      query.where(likesTable.createdAt.isBiggerThanValue(after.microsecondsSinceEpoch));
    }
    final min = await query.map((row) => row.read(firstCreatedAt)).getSingleOrNull();
    return min?.toDateTime;
  }

  Stream<int> watchUnreadCount({required DateTime? after}) {
    final unreadCount = likesTable.eventReference.count();
    final query = selectOnly(likesTable)..addColumns([unreadCount]);

    if (after != null) {
      query.where(
        likesTable
            .normalizedTimestamp(likesTable.createdAt)
            .isBiggerThanValue(after.microsecondsSinceEpoch),
      );
    }

    return query.map((row) => row.read(unreadCount)!).watchSingle();
  }
}
