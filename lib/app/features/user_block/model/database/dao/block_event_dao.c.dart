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
      case GenericRepostEntity.kind:
        eventReference = GenericRepostEntity.fromEventMessage(event).toEventReference();
      case ReplaceablePrivateDirectMessageEntity.kind:
        eventReference =
            ReplaceablePrivateDirectMessageEntity.fromEventMessage(event).toEventReference();
      case PrivateMessageReactionEntity.kind:
        eventReference = PrivateMessageReactionEntity.fromEventMessage(event).toEventReference();
      default:
        return;
    }

    final dbModel = event.toBlockEventDbModel(eventReference);

    await into(db.blockEventTable).insert(dbModel, mode: InsertMode.insertOrReplace);
  }

  Future<EventMessage> getByReference(EventReference eventReference) async {
    final result = await (select(db.blockEventTable)
          ..where((table) => table.eventReference.equalsValue(eventReference)))
        .getSingle();
    return result.toEventMessage();
  }

  Future<EventMessage> getById(String id) async {
    final result =
        await (select(db.blockEventTable)..where((table) => table.id.equals(id))).getSingle();
    return result.toEventMessage();
  }

  Future<void> deleteByEventReference(EventReference eventReference) async {
    await (delete(db.blockEventTable)
          ..where((table) => table.eventReference.equalsValue(eventReference)))
        .go();
  }
}
