// SPDX-License-Identifier: ice License 1.0

part of '../blocked_users_database.c.dart';

@Riverpod(keepAlive: true)
BlockEventStatusDao blockEventStatusDao(Ref ref) =>
    BlockEventStatusDao(ref.watch(blockedUsersDatabaseProvider));

@DriftAccessor(tables: [BlockEventTable, BlockEventStatusTable])
class BlockEventStatusDao extends DatabaseAccessor<BlockedUsersDatabase>
    with _$BlockEventStatusDaoMixin {
  BlockEventStatusDao(super.db);

  Future<void> add({
    required EventMessage event,
    required BlockedUserStatus status,
    required String receiverPubkey,
    required String receiverMasterPubkey,
  }) async {
    final EventReference eventReference;

    final sharedId = event.sharedId;

    if (sharedId == null) {
      throw IncorrectShareableIdentifierException(sharedId);
    }

    switch (event.kind) {
      case BlockedUserEntity.kind:
        eventReference = BlockedUserEntity.fromEventMessage(event).toEventReference();
      default:
        return;
    }

    final existingStatus = await (select(db.blockEventStatusTable)
          ..where((table) => table.eventReference.equalsValue(eventReference))
          ..limit(1))
        .getSingleOrNull();

    if (existingStatus == null) {
      await into(db.blockEventStatusTable).insert(
        BlockEventStatusTableCompanion(
          status: Value(status),
          sharedId: Value(sharedId),
          receiverPubkey: Value(receiverPubkey),
          eventReference: Value(eventReference),
          receiverMasterPubkey: Value(receiverMasterPubkey),
        ),
      );
    } else if (existingStatus.status.index < status.index) {
      await into(db.blockEventStatusTable).insert(
        BlockEventStatusTableCompanion(
          status: Value(status),
          sharedId: Value(sharedId),
          eventReference: Value(eventReference),
          receiverPubkey: Value(receiverPubkey),
          receiverMasterPubkey: Value(receiverMasterPubkey),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  Future<void> markAsDeleted(List<ReplaceableEventReference> eventReferences) async {
    final sharedIds = eventReferences.map((eventReference) => eventReference.dTag).toList();

    final matchingBlockEvents = await (select(db.blockEventStatusTable)
          ..where((table) => table.sharedId.isIn(sharedIds)))
        .get();

    for (final blockEvent in matchingBlockEvents) {
      if (blockEvent.status == BlockedUserStatus.deleted) {
        continue;
      }
      await into(db.blockEventStatusTable).insert(
        BlockEventStatusTableCompanion(
          sharedId: Value(blockEvent.sharedId),
          eventReference: Value(blockEvent.eventReference),
          receiverPubkey: Value(blockEvent.receiverPubkey),
          receiverMasterPubkey: Value(blockEvent.receiverMasterPubkey),
          status: const Value(BlockedUserStatus.deleted),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  Future<void> markAsDelivered(List<ReplaceableEventReference> eventReferences) async {
    final sharedIds = eventReferences.map((eventReference) => eventReference.dTag).toList();

    final matchingBlockEvents = await (select(db.blockEventStatusTable)
          ..where((table) => table.sharedId.isIn(sharedIds)))
        .get();

    for (final blockEvent in matchingBlockEvents) {
      if (blockEvent.status == BlockedUserStatus.delivered) {
        continue;
      }
      await into(db.blockEventStatusTable).insert(
        BlockEventStatusTableCompanion(
          sharedId: Value(blockEvent.sharedId),
          eventReference: Value(blockEvent.eventReference),
          receiverPubkey: Value(blockEvent.receiverPubkey),
          receiverMasterPubkey: Value(blockEvent.receiverMasterPubkey),
          status: const Value(BlockedUserStatus.delivered),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }
}

enum BlockedUserStatus {
  created,
  failed,
  delivered,
  deleted;
}
