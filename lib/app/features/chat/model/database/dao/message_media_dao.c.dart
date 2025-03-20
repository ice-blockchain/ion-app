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
    final existRecord = await (select(messageMediaTable)
          ..where((t) => t.eventMessageId.equals(messageMedia.eventMessageId.value))
          ..where((t) => t.remoteUrl.equals(messageMedia.remoteUrl.value ?? '')))
        .getSingleOrNull();

    if (existRecord != null) {
      await updateById(
        existRecord.id,
        messageMedia.eventMessageId.value,
        messageMedia.remoteUrl.value ?? '',
        messageMedia.status.value,
      );
      return existRecord.id;
    }
    return into(messageMediaTable).insert(messageMedia, mode: InsertMode.insertOrReplace);
  }

  Stream<List<MessageMediaTableData>> watchByEventId(String eventId) {
    return (select(messageMediaTable)..where((t) => t.eventMessageId.equals(eventId))).watch();
  }

  Future<void> updateById(
    int id,
    String eventMessageId,
    String remoteUrl,
    MessageMediaStatus status,
  ) async {
    await (update(messageMediaTable)..where((t) => t.id.equals(id))).write(
      MessageMediaTableCompanion(
        eventMessageId: Value(eventMessageId),
        remoteUrl: Value(remoteUrl),
        status: Value(status),
      ),
    );
  }

  Future<void> cancel(int id) async {
    await (delete(messageMediaTable)..where((t) => t.id.equals(id))).go();
  }
}
