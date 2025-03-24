// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationMessageDao conversationMessageDao(Ref ref) =>
    ConversationMessageDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(
  tables: [
    ConversationMessageTable,
    EventMessageTable,
    MessageStatusTable,
    ConversationTable,
  ],
)
class ConversationMessageDao extends DatabaseAccessor<ChatDatabase>
    with _$ConversationMessageDaoMixin {
  ConversationMessageDao(super.db);

  Stream<int> getUnreadMessagesCount({
    required String conversationId,
    required String currentUserMasterPubkey,
  }) {
    final query = select(conversationMessageTable).join([
      innerJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(conversationMessageTable.eventMessageId),
      ),
      innerJoin(
        messageStatusTable,
        messageStatusTable.eventMessageId.equalsExp(conversationMessageTable.eventMessageId),
      ),
    ])
      ..where(conversationMessageTable.conversationId.equals(conversationId))
      ..where(messageStatusTable.status.equals(MessageDeliveryStatus.received.index))
      ..where(messageStatusTable.masterPubkey.equals(currentUserMasterPubkey));

    return query.watch().map((rows) => rows.length);
  }

  Stream<int> getAllUnreadMessagesCountInArchive(String currentUserMasterPubkey) {
    final query = select(messageStatusTable).join([
      innerJoin(
        conversationMessageTable,
        conversationMessageTable.eventMessageId.equalsExp(messageStatusTable.eventMessageId),
      ),
      innerJoin(
        conversationTable,
        conversationTable.id.equalsExp(conversationMessageTable.conversationId),
      ),
    ])
      ..where(messageStatusTable.status.equals(MessageDeliveryStatus.received.index))
      ..where(messageStatusTable.masterPubkey.equals(currentUserMasterPubkey))
      ..where(conversationTable.isArchived.equals(true));

    return query.watch().map((rows) => rows.length);
  }

  Stream<int> getAllUnreadMessagesCount(String currentUserMasterPubkey) {
    final query = select(messageStatusTable)
      ..where((table) => table.status.equals(MessageDeliveryStatus.received.index))
      ..where((table) => table.masterPubkey.equals(currentUserMasterPubkey));

    return query.watch().map((rows) => rows.length);
  }

  Stream<Map<DateTime, List<EventMessage>>> getMessages({
    required String conversationId,
    required String currentUserMasterPubkey,
  }) {
    final query = select(conversationMessageTable).join([
      innerJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(conversationMessageTable.eventMessageId),
      ),
      innerJoin(
        messageStatusTable,
        messageStatusTable.eventMessageId.equalsExp(conversationMessageTable.eventMessageId),
      ),
    ])
      ..where(conversationMessageTable.conversationId.equals(conversationId))
      ..where(messageStatusTable.masterPubkey.equals(currentUserMasterPubkey))
      ..where(messageStatusTable.status.isNotIn([MessageDeliveryStatus.deleted.index]))
      ..orderBy([OrderingTerm.desc(eventMessageTable.createdAt)]);

    return query.watch().map((rows) {
      final groupedMessages = <DateTime, List<EventMessage>>{};

      for (final row in rows) {
        final eventMessage = row.readTable(eventMessageTable).toEventMessage();

        final dateKey = DateTime(
          eventMessage.createdAt.year,
          eventMessage.createdAt.month,
          eventMessage.createdAt.day,
        );

        groupedMessages.putIfAbsent(dateKey, () => []).add(eventMessage);
      }

      return groupedMessages;
    });
  }

  Future<EventMessage> getEventMessage({
    required Ref ref,
    required String messageId,
  }) async {
    final message =
        await (select(eventMessageTable)..where((table) => table.id.equals(messageId))).getSingle();

    return message.toEventMessage();
  }

  Future<void> removeMessages({
    required Ref ref,
    required EventMessage deleteRequest,
    required List<String> messageIds,
  }) async {
    final eventMessageDao = ref.watch(eventMessageDaoProvider);

    await eventMessageDao.add(deleteRequest);

    await (update(messageStatusTable)..where((table) => table.eventMessageId.isIn(messageIds)))
        .write(
      const MessageStatusTableCompanion(
        status: Value(MessageDeliveryStatus.deleted),
      ),
    );
  }
}
