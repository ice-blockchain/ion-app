// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/comments_table.c.dart';

part 'comments_dao.c.g.dart';

@DriftAccessor(tables: [CommentsTable])
class CommentsDao extends DatabaseAccessor<NotificationsDatabase> with _$CommentsDaoMixin {
  CommentsDao({required NotificationsDatabase db}) : super(db);

  Future<void> insert(Comment comment) async {
    await into(db.commentsTable).insert(comment, mode: InsertMode.insertOrReplace);
  }

  Future<List<Comment>> getAll() async {
    return (select(commentsTable)..orderBy([(t) => OrderingTerm.desc(commentsTable.createdAt)]))
        .get();
  }

  Future<DateTime?> getLastCreatedAt(CommentType type) async {
    final maxCreatedAt = commentsTable.createdAt.max();
    final max = await (selectOnly(commentsTable)
          ..addColumns([maxCreatedAt])
          ..where(commentsTable.type.equalsValue(type)))
        .map((row) => row.read(maxCreatedAt))
        .getSingleOrNull();
    return max?.toDateTime;
  }

  Future<DateTime?> getFirstCreatedAt(CommentType type, {DateTime? after}) async {
    final firstCreatedAt = commentsTable.createdAt.min();
    final query = selectOnly(commentsTable)
      ..addColumns([firstCreatedAt])
      ..where(commentsTable.type.equalsValue(type));
    if (after != null) {
      query.where(commentsTable.createdAt.isBiggerThanValue(after.microsecondsSinceEpoch));
    }
    final min = await query.map((row) => row.read(firstCreatedAt)).getSingleOrNull();
    return min?.toDateTime;
  }

  Stream<int> watchUnreadCount({required DateTime? after}) {
    final unreadCount = commentsTable.eventReference.count();
    final query = selectOnly(commentsTable)..addColumns([unreadCount]);

    if (after != null) {
      query.where(
        commentsTable.createdAt.isBiggerThanValue(after.microsecondsSinceEpoch),
      );
    }

    return query.map((row) => row.read(unreadCount)!).watchSingle();
  }
}
