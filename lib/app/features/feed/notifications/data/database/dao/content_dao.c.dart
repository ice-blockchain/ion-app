// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/content_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_dao.c.g.dart';

@Riverpod(keepAlive: true)
ContentDao contentDao(Ref ref) => ContentDao(ref.watch(notificationsDatabaseProvider));

@DriftAccessor(tables: [ContentTable])
class ContentDao extends DatabaseAccessor<NotificationsDatabase> with _$ContentDaoMixin {
  ContentDao(super.db);

  Future<void> insert(ContentNotification content) {
    return into(contentTable).insertOnConflictUpdate(content);
  }

  Future<List<ContentNotification>> getAll() {
    return (select(contentTable)..orderBy([(c) => OrderingTerm.desc(c.createdAt)])).get();
  }

  Future<List<ContentNotification>> getAllByType(ContentType type) {
    return (select(contentTable)
          ..where((c) => c.type.equalsValue(type))
          ..orderBy([(c) => OrderingTerm.desc(c.createdAt)]))
        .get();
  }

  Stream<int> watchUnreadCount({required DateTime after}) {
    final query = selectOnly(contentTable)
      ..addColumns([contentTable.eventReference.count()])
      ..where(contentTable.createdAt.isBiggerThanValue(after.microsecondsSinceEpoch));

    return query.map((row) => row.read(contentTable.eventReference.count()) ?? 0).watchSingle();
  }

  Future<DateTime?> getLastCreatedAt() async {
    final query = selectOnly(contentTable)
      ..addColumns([contentTable.createdAt])
      ..orderBy([OrderingTerm.desc(contentTable.createdAt)])
      ..limit(1);

    final result = await query.getSingleOrNull();
    final microseconds = result?.read(contentTable.createdAt);
    return microseconds?.toDateTime;
  }

  Future<DateTime?> getFirstCreatedAt({DateTime? after}) async {
    final query = selectOnly(contentTable)
      ..addColumns([contentTable.createdAt])
      ..orderBy([OrderingTerm.asc(contentTable.createdAt)])
      ..limit(1);

    if (after != null) {
      query.where(contentTable.createdAt.isBiggerThanValue(after.microsecondsSinceEpoch));
    }

    final result = await query.getSingleOrNull();
    final microseconds = result?.read(contentTable.createdAt);
    return microseconds?.toDateTime;
  }
}
