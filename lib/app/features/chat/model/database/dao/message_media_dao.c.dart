// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
MessageMediaDao messageMediaDao(Ref ref) => MessageMediaDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(
  tables: [
    MessageMediaTable,
  ],
)
class MessageMediaDao extends DatabaseAccessor<ChatDatabase> with _$MessageMediaDaoMixin {
  MessageMediaDao(super.db);

  Future<int> add(MessageMediaTableCompanion messageMedia) async {
    final existRecord = await (select(db.messageMediaTable)
          ..where((t) => t.eventMessageId.equals(messageMedia.eventMessageId.value))
          ..where((t) => t.remoteUrl.equals(messageMedia.remoteUrl.value ?? '')))
        .getSingleOrNull();

    if (existRecord != null) {
      return existRecord.id;
    }
    return into(db.messageMediaTable).insert(messageMedia, mode: InsertMode.insertOrReplace);
  }

  Stream<List<MessageMediaTableData>> watchByEventId(String eventId) {
    return (select(db.messageMediaTable)..where((t) => t.eventMessageId.equals(eventId))).watch();
  }

  Future<void> updateById(int id, MessageMediaTableCompanion messageMedia) async {
    final existRecord =
        await (select(db.messageMediaTable)..where((t) => t.id.equals(id))).getSingleOrNull();

    if (existRecord == null) {
      return;
    }

    await (update(db.messageMediaTable)..where((t) => t.id.equals(id))).write(messageMedia);
  }

  Future<void> updateByRemoteUrl(String remoteUrl, MessageMediaTableCompanion messageMedia) async {
    await (update(db.messageMediaTable)..where((t) => t.remoteUrl.equals(remoteUrl)))
        .write(messageMedia);
  }
}
