// SPDX-License-Identifier: ice License 1.0

part of '../blocked_users_database.c.dart';

@Riverpod(keepAlive: true)
BlockEventDao blockEventDao(Ref ref) => BlockEventDao(ref.watch(blockedUsersDatabaseProvider));

@DriftAccessor(tables: [BlockEventTable])
class BlockEventDao extends DatabaseAccessor<BlockedUsersDatabase> with _$BlockEventDaoMixin {
  BlockEventDao(super.db);

  Future<void> add(EventMessage event) async {
    final EventReference eventReference;
    switch (event.kind) {
      case BlockedUserEntity.kind:
        eventReference = BlockedUserEntity.fromEventMessage(event).toEventReference();
      default:
        return;
    }

    final dbModel = event.toBlockEventDbModel(eventReference);

    await into(db.blockEventTable).insert(dbModel, mode: InsertMode.insertOrReplace);
  }

  Future<DateTime?> getLatestBlockEventDate() async {
    final query = select(blockEventTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);

    return (await query.getSingleOrNull())?.createdAt;
  }

  Future<DateTime?> getEarliestBlockEventDate({DateTime? after}) async {
    final query = select(blockEventTable);

    if (after != null) {
      query.where((t) => t.createdAt.isBiggerThanValue(after));
    }

    query
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
      ..limit(1);

    return (await query.getSingleOrNull())?.createdAt;
  }

  Future<List<EventMessage>> getBlockedUsersEvents(String currentUserMasterPubkey) async {
    final query = select(db.blockEventTable).join([
      leftOuterJoin(
        db.deletedBlockEventTable,
        db.deletedBlockEventTable.eventReference.equalsExp(db.blockEventTable.eventReference) &
            db.deletedBlockEventTable.isDeleted.equals(true),
      ),
    ])
      ..where(db.blockEventTable.masterPubkey.equals(currentUserMasterPubkey))
      ..where(db.deletedBlockEventTable.eventReference.isNull());

    final result = await query.get();

    return result.map((row) => row.readTable(db.blockEventTable).toEventMessage()).toList();
  }

  Future<List<EventMessage>> getBlockedByUsersEvents(String currentUserMasterPubkey) async {
    final query = select(db.blockEventTable).join([
      leftOuterJoin(
        db.deletedBlockEventTable,
        db.deletedBlockEventTable.eventReference.equalsExp(db.blockEventTable.eventReference) &
            db.deletedBlockEventTable.isDeleted.equals(true),
      ),
    ])
      ..where(db.blockEventTable.masterPubkey.isNotValue(currentUserMasterPubkey))
      ..where(db.deletedBlockEventTable.eventReference.isNull());

    final result = await query.get();

    return result.map((row) => row.readTable(db.blockEventTable).toEventMessage()).toList();
  }

  Future<void> markAsDeleted(List<EventReference> eventReferences) async {
    await (update(db.deletedBlockEventTable)
          ..where((table) => table.eventReference.isInValues(eventReferences)))
        .write(const DeletedBlockEventTableCompanion(isDeleted: Value(true)));
  }
}
