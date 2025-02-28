// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationMessageDataDao conversationMessageDataDao(Ref ref) =>
    ConversationMessageDataDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(
  tables: [
    MessageStatusTable,
    EventMessageTable,
    ConversationMessageTable,
  ],
)
class ConversationMessageDataDao extends DatabaseAccessor<ChatDatabase>
    with _$ConversationMessageDataDaoMixin {
  ConversationMessageDataDao(super.db);

  Future<void> add({
    required String masterPubkey,
    required String eventMessageId,
    required MessageDeliveryStatus status,
    DateTime? createdAt,
  }) async {
    if (status == MessageDeliveryStatus.read && createdAt != null) {
      final existingRow = await (select(messageStatusTable)
            ..where((table) => table.masterPubkey.equals(masterPubkey))
            ..where((table) => table.eventMessageId.equals(eventMessageId))
            ..limit(1))
          .getSingleOrNull();

      if (existingRow == null) {
        await into(messageStatusTable).insert(
          MessageStatusTableCompanion(
            status: Value(status),
            masterPubkey: Value(masterPubkey),
            eventMessageId: Value(eventMessageId),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
      final conversationMessageTableData = await (select(conversationMessageTable)
            ..where((table) => table.eventMessageId.equals(eventMessageId))
            ..limit(1))
          .getSingleOrNull();

      if (conversationMessageTableData != null) {
        final conversationId = conversationMessageTableData.conversationId;

        final conversationMessageTableDataList = await (select(conversationMessageTable)
              ..where((table) => table.conversationId.equals(conversationId)))
            .get();

        final allEventMessagesId =
            conversationMessageTableDataList.map((e) => e.eventMessageId).toList();

        final eventMessagesBeforeEvent = await (select(eventMessageTable)
              ..where((table) => table.id.isIn(allEventMessagesId))
              ..where((table) => table.createdAt.isSmallerThanValue(createdAt)))
            .get();

        final eventMessagesId = eventMessagesBeforeEvent.map((e) => e.id).toList()
          ..add(eventMessageId);

        final messageStatusTableData = await (select(messageStatusTable)
              ..where((table) => table.eventMessageId.isIn(eventMessagesId))
              ..where((table) => table.masterPubkey.equals(masterPubkey))
              ..where((table) => table.status.isIn([MessageDeliveryStatus.received.index])))
            .get();

        await batch((batch) {
          final rows = messageStatusTableData.map((row) => row.copyWith(status: status)).toList();

          batch.replaceAll(messageStatusTable, rows);
        });
      }
    } else {
      final existingRow = await (select(messageStatusTable)
            ..where((table) => table.masterPubkey.equals(masterPubkey))
            ..where((table) => table.eventMessageId.equals(eventMessageId))
            ..limit(1))
          .getSingleOrNull();

      if (existingRow != null) {
        if (status.index > existingRow.status.index) {
          await update(messageStatusTable).replace(existingRow.copyWith(status: status));
        }
      } else {
        final eventMessageExists = await (select(eventMessageTable)
              ..where((table) => table.id.equals(eventMessageId))
              ..limit(1))
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
  }

  Stream<MessageDeliveryStatus> messageStatus(String eventMessageId) {
    final existingRows = (select(messageStatusTable)
          ..where((table) => table.eventMessageId.equals(eventMessageId)))
        .watch();

    return existingRows.map((rows) {
      if (rows.every((row) => row.status == MessageDeliveryStatus.deleted)) {
        return MessageDeliveryStatus.deleted;
      } else
      // First check if any of the rows are failed
      if (rows.any((row) => row.status == MessageDeliveryStatus.failed)) {
        return MessageDeliveryStatus.failed;
      } else
      // Check if all rows are have read status
      if (rows.every((row) => row.status == MessageDeliveryStatus.read)) {
        return MessageDeliveryStatus.read;
      } else
      // Check if all rows are have received status
      if (rows.every((row) => row.status.index >= MessageDeliveryStatus.received.index)) {
        return MessageDeliveryStatus.received;
      } else
      // Check if all rows have delivery status or higher
      if (rows.every((row) => row.status.index > MessageDeliveryStatus.created.index)) {
        return MessageDeliveryStatus.sent;
      }

      return MessageDeliveryStatus.created;
    });
  }

  Future<MessageDeliveryStatus?> checkMessageStatus({
    required String masterPubkey,
    required String eventMessageId,
  }) async {
    final existingStatus = (select(messageStatusTable)
          ..where((table) => table.masterPubkey.equals(masterPubkey))
          ..where(
            (table) => table.eventMessageId.equals(eventMessageId),
          )
          ..limit(1))
        .getSingleOrNull()
        .then((value) => value?.status);

    return existingStatus;
  }
}

enum MessageDeliveryStatus {
  failed,
  created,
  sent,
  received,
  read,
  deleted;
}
