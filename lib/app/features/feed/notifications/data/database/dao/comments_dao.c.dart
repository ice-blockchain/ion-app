// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/comments_table.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_dao.c.g.dart';

@Riverpod(keepAlive: true)
CommentsDao commentsDao(Ref ref) => CommentsDao(db: ref.watch(notificationsDatabaseProvider));

@DriftAccessor(tables: [CommentsTable])
class CommentsDao extends DatabaseAccessor<NotificationsDatabase> with _$CommentsDaoMixin {
  CommentsDao({required NotificationsDatabase db}) : super(db);

  Future<void> clear() async {
    await delete(commentsTable).go();
  }

  Future<void> insert(IonConnectEntity entity, {required CommentType type}) async {
    await into(db.commentsTable).insert(
      Comment(eventReference: entity.toEventReference(), createdAt: entity.createdAt, type: type),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<List<Comment>> getAll() async {
    return (select(commentsTable)..orderBy([(t) => OrderingTerm.desc(commentsTable.createdAt)]))
        .get();
  }

  // ..addColumns([eventMessageTable.createdAt.max(),])
  Future<Comment?> getLast(CommentType type) async {
    final query = select(commentsTable)
      ..where((t) => t.type.equalsValue(type))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  Stream<int> watchUnreadCount({required DateTime? after}) {
    final totalCount = commentsTable.eventReference.count();
    final query = select(commentsTable);
    if (after != null) {
      query.where((t) => t.createdAt.isBiggerThanValue(after));
    }
    return query.addColumns([totalCount]).map((row) => row.read(totalCount)!).watchSingle();
  }
}
