// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationMessageStatusDao conversationMessageStatusDao(Ref ref) =>
    ConversationMessageStatusDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [MessageStatusTable])
class ConversationMessageStatusDao extends DatabaseAccessor<ChatDatabase>
    with _$ConversationMessageStatusDaoMixin {
  ConversationMessageStatusDao(super.db);

  Future<void> updateConversationMessageStatusData({
    required String masterPubkey,
    required String eventMessageId,
    required MessageDeliveryStatus status,
  }) async {
    final existingRow = await (select(messageStatusTable)
          ..where((table) => table.masterPubkey.equals(masterPubkey))
          ..where((table) => table.eventMessageId.equals(eventMessageId)))
        .getSingleOrNull();

    if (existingRow != null) {
      if (status.index > existingRow.status.index) {
        await update(messageStatusTable).replace(existingRow.copyWith(status: status));
      }
    } else {
      await into(messageStatusTable).insert(
        MessageStatusTableCompanion(
          status: Value(status),
          masterPubkey: Value(masterPubkey),
          eventMessageId: Value(eventMessageId),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  Stream<MessageDeliveryStatus> getMessageStatus(String eventMessageId) {
    final existingRows = (select(messageStatusTable)
          ..where((table) => table.eventMessageId.equals(eventMessageId)))
        .watch();

    return existingRows.map((rows) {
      if (rows.every((row) => row.status == MessageDeliveryStatus.sent)) {
        return MessageDeliveryStatus.sent;
      }
      if (rows.any((row) => row.status == MessageDeliveryStatus.failed)) {
        return MessageDeliveryStatus.failed;
      }

      return MessageDeliveryStatus.created;
    });
  }
}

enum MessageDeliveryStatus { created, sent, received, read, deleted, failed }
