// SPDX-License-Identifier: ice License 1.0

part of '../block_user_database.c.dart';

@Riverpod(keepAlive: true)
BlockEventDao blockEventDao(Ref ref) => BlockEventDao(ref.watch(blockedUsersDatabaseProvider));

@DriftAccessor(tables: [BlockEventTable, UnblockEventTable])
class BlockEventDao extends DatabaseAccessor<BlockUserDatabase> with _$BlockEventDaoMixin {
  BlockEventDao(super.db);

  Future<void> add(EventMessage event) async {
    if (event.kind != BlockedUserEntity.kind) return;

    final eventReference = BlockedUserEntity.fromEventMessage(event).toEventReference();
    final dbModel = event.toBlockEventDbModel(eventReference);

    await into(db.blockEventTable).insert(dbModel, mode: InsertMode.insertOrReplace);
  }

  Future<EventReference?> getBlockEventReference({
    required String masterPubkey,
    required String blockedUserMasterPubkey,
  }) async {
    final blockedUsers = await getBlockedUsersEvents(masterPubkey);
    final blockedUsersEntities = blockedUsers.map(BlockedUserEntity.fromEventMessage).toList();

    final blockedUserEntity = blockedUsersEntities.firstWhereOrNull(
      (entity) => entity.data.blockedMasterPubkeys.contains(blockedUserMasterPubkey),
    );

    return blockedUserEntity?.toEventReference();
  }

  Future<DateTime?> getLatestBlockEventDate() async {
    final query = select(blockEventTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row?.createdAt.toDateTime;
  }

  Future<DateTime?> getEarliestBlockEventDate({DateTime? after}) async {
    final query = select(blockEventTable);

    if (after != null) {
      query.where((t) => t.createdAt.isBiggerThanValue(after.microsecondsSinceEpoch));
    }

    query
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row?.createdAt.toDateTime;
  }

  JoinedSelectStatement<HasResultSet, dynamic> _blockedUsersQuery(String currentUserMasterPubkey) {
    return select(db.blockEventTable).join([
      leftOuterJoin(
        db.unblockEventTable,
        db.unblockEventTable.eventReference.equalsExp(db.blockEventTable.eventReference),
      ),
    ])
      ..where(db.blockEventTable.masterPubkey.equals(currentUserMasterPubkey))
      ..where(db.unblockEventTable.eventReference.isNull());
  }

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
  ) {
    return select(db.blockEventTable).join([
      leftOuterJoin(
        db.unblockEventTable,
        db.unblockEventTable.eventReference.equalsExp(db.blockEventTable.eventReference),
      ),
    ])
      ..where(db.blockEventTable.masterPubkey.isNotValue(currentUserMasterPubkey))
      ..where(db.unblockEventTable.eventReference.isNull());
  }

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
