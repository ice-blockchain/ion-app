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

  Future<int> add({
    required String eventMessageId,
    required MessageMediaStatus status,
    String? cacheKey,
    String? remoteUrl,
  }) async {
    final existRecord = await (select(messageMediaTable)
          ..where((t) => t.eventMessageId.equals(eventMessageId))
          ..where((t) => t.remoteUrl.equalsNullable(remoteUrl)))
        .getSingleOrNull();

    if (existRecord != null) {
      await updateById(
        existRecord.id,
        eventMessageId,
        remoteUrl!,
        status,
      );
      return existRecord.id;
    }
    return into(messageMediaTable).insert(
      MessageMediaTableCompanion(
        eventMessageId: Value(eventMessageId),
        status: Value(status),
        cacheKey: Value(cacheKey),
        remoteUrl: Value(remoteUrl),
      ),
    );
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

  Future<List<int>> addBatch({
    required String eventMessageId,
    required List<String> cacheKeys,
  }) async {
    await batch((b) {
      b
        ..deleteWhere(
          messageMediaTable,
          (t) => t.eventMessageId.equals(eventMessageId),
        )
        ..insertAll(
          messageMediaTable,
          cacheKeys
              .map(
                (cacheKey) => MessageMediaTableCompanion(
                  eventMessageId: Value(eventMessageId),
                  cacheKey: Value(cacheKey),
                  status: const Value(MessageMediaStatus.processing),
                ),
              )
              .toList(),
          mode: InsertMode.insertOrIgnore,
        );
    });
    final result = await (select(messageMediaTable)
          ..where((t) => t.eventMessageId.equals(eventMessageId)))
        .get();
    return result.map((e) => e.id).toList();
  }
}
