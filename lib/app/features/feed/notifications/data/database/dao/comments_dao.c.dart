// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/comments_table.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_dao.c.g.dart';

@Riverpod(keepAlive: true)
CommentsDao coinsDao(Ref ref) => CommentsDao(db: ref.watch(notificationsDatabaseProvider));

@DriftAccessor(tables: [CommentsTable])
class CommentsDao extends DatabaseAccessor<NotificationsDatabase> with _$CommentsDaoMixin {
  CommentsDao({required NotificationsDatabase db}) : super(db);

  Future<void> clear() async {
    await delete(commentsTable).go();
  }

  Future<List<Comment>> getAll() {
    return select(commentsTable).get();
  }

  Future<void> insert(IonConnectEntity entity) async {
    await into(db.commentsTable).insert(
      Comment(eventReference: entity.toEventReference(), createdAt: entity.createdAt),
      mode: InsertMode.insertOrReplace,
    );
  }
}
