// SPDX-License-Identifier: ice License 1.0

part of '../blocked_users_database.c.dart';

@Riverpod(keepAlive: true)
BlockEventDao blockEventDao(Ref ref) => BlockEventDao(ref.watch(blockedUsersDatabaseProvider));

@DriftAccessor(tables: [BlockEventTable, BlockEventStatusTable])
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

    return (await query.getSingleOrNull())?.createdAt.toDateTime;
  }

  Future<DateTime?> getEarliestBlockEventDate({DateTime? after}) async {
    final query = select(blockEventTable);

    if (after != null) {
      query.where((t) => t.createdAt.isBiggerThanValue(after.microsecondsSinceEpoch));
    }

    query
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
      ..limit(1);

    return (await query.getSingleOrNull())?.createdAt.toDateTime;
  }

  JoinedSelectStatement<HasResultSet, dynamic> _blockedUsersQuery(String currentUserMasterPubkey) =>
      select(db.blockEventTable).join([
        leftOuterJoin(
          db.blockEventStatusTable,
          db.blockEventStatusTable.eventReference.equalsExp(db.blockEventTable.eventReference),
        ),
      ])
        ..where(db.blockEventTable.masterPubkey.equals(currentUserMasterPubkey))
        ..where(db.blockEventStatusTable.status.isNotValue(BlockedUserStatus.deleted.index));

  Future<List<EventMessage>> getBlockedUsersEvents(String currentUserMasterPubkey) async {
    final result = await _blockedUsersQuery(currentUserMasterPubkey).get();

    return result.map((row) => row.readTable(db.blockEventTable).toEventMessage()).toList();
  }

  Stream<List<EventMessage>> watchBlockedUsersEvents(String currentUserMasterPubkey) {
    return _blockedUsersQuery(currentUserMasterPubkey).watch().map(
          (rows) => rows.map((row) => row.readTable(db.blockEventTable).toEventMessage()).toList(),
        );
  }

  JoinedSelectStatement<HasResultSet, dynamic> _blockedByUsersQuery(
    String currentUserMasterPubkey,
  ) =>
      select(db.blockEventTable).join([
        leftOuterJoin(
          db.blockEventStatusTable,
          db.blockEventStatusTable.eventReference.equalsExp(db.blockEventTable.eventReference),
        ),
      ])
        ..where(db.blockEventTable.masterPubkey.isNotValue(currentUserMasterPubkey))
        ..where(db.blockEventStatusTable.status.isNotValue(BlockedUserStatus.deleted.index));

  Future<List<EventMessage>> getBlockedByUsersEvents(String currentUserMasterPubkey) async {
    final result = await _blockedByUsersQuery(currentUserMasterPubkey).get();

    return result.map((row) => row.readTable(db.blockEventTable).toEventMessage()).toList();
  }

  Stream<List<EventMessage>> watchBlockedByUsersEvents(String currentUserMasterPubkey) {
    return _blockedByUsersQuery(currentUserMasterPubkey).watch().map(
          (rows) => rows.map((row) => row.readTable(db.blockEventTable).toEventMessage()).toList(),
        );
  }
}
