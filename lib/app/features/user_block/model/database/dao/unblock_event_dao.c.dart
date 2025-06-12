// SPDX-License-Identifier: ice License 1.0

part of '../block_user_database.c.dart';

@riverpod
UnblockEventDao unblockEventDao(Ref ref) {
  final keepAlive = ref.keepAlive();
  onLogout(ref, keepAlive.close);
  return UnblockEventDao(ref.watch(blockedUsersDatabaseProvider));
}

@DriftAccessor(tables: [UnblockEventTable])
class UnblockEventDao extends DatabaseAccessor<BlockUserDatabase> with _$UnblockEventDaoMixin {
  UnblockEventDao(super.db);

  Future<void> add(EventReference eventReference) async {
    await into(db.unblockEventTable).insert(
      UnblockEventTableCompanion(eventReference: Value(eventReference)),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<bool> isUnblocked(EventReference eventReference) async {
    final query = select(db.unblockEventTable)
      ..limit(1)
      ..where((table) => table.eventReference.equalsValue(eventReference));

    final result = await query.getSingleOrNull();
    return result != null;
  }
}
