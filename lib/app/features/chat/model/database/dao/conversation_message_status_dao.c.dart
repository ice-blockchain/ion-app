// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationMessageStatusDao conversationMessageStatusDao(Ref ref) =>
    ConversationMessageStatusDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [MessageStatusTable, EventMessageTable])
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
      final eventMessageExists = await (select(eventMessageTable)
            ..where((table) => table.id.equals(eventMessageId)))
          .getSingleOrNull();

      if (eventMessageExists == null) {
        return;
      }

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
      // First check if any of the rows are failed
      if (rows.any((row) => row.status == MessageDeliveryStatus.failed)) {
        return MessageDeliveryStatus.failed;
      }
      // Check if all rows are have delivery status
      if (rows.every((row) => row.status == MessageDeliveryStatus.received)) {
        return MessageDeliveryStatus.received;
      }
      // Check if all rows have delivery status or higher
      if (rows.every((row) => row.status.index > MessageDeliveryStatus.created.index)) {
        return MessageDeliveryStatus.sent;
      }

      return MessageDeliveryStatus.created;
    });
  }
}

enum MessageDeliveryStatus {
  failed,
  created,
  sent,
  received,
  read,
  deleted,
}
