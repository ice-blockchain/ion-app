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
        eventMessageTable.eventReference.equalsExp(conversationMessageTable.messageEventReference),
      ),
      innerJoin(
        messageStatusTable,
        messageStatusTable.messageEventReference
            .equalsExp(conversationMessageTable.messageEventReference),
      ),
    ])
      ..where(conversationMessageTable.conversationId.equals(conversationId))
      ..where(messageStatusTable.masterPubkey.equals(currentUserMasterPubkey))
      ..where(messageStatusTable.status.equals(MessageDeliveryStatus.received.index));

    return query.watch().map((rows) => rows.length);
  }

  Stream<int> getAllUnreadMessagesCountInArchive(
    String currentUserMasterPubkey,
  ) {
    final query = select(messageStatusTable).join([
      innerJoin(
        conversationMessageTable,
        conversationMessageTable.messageEventReference
            .equalsExp(messageStatusTable.messageEventReference),
      ),
      innerJoin(
        conversationTable,
        conversationTable.id.equalsExp(conversationMessageTable.conversationId),
      ),
    ])
      ..where(conversationTable.isArchived.equals(true))
      ..where(messageStatusTable.masterPubkey.equals(currentUserMasterPubkey))
      ..where(messageStatusTable.status.equals(MessageDeliveryStatus.received.index));

    return query.watch().map((rows) => rows.length);
  }

  Stream<int> getAllUnreadMessagesCount(
    String currentUserMasterPubkey,
    List<String> mutedConversationIds,
  ) {
    final query = select(messageStatusTable).join([
      innerJoin(
        conversationMessageTable,
        conversationMessageTable.messageEventReference
            .equalsExp(messageStatusTable.messageEventReference),
      ),
    ])
      ..where(
        conversationMessageTable.conversationId.isNotIn(mutedConversationIds),
      )
      ..where(messageStatusTable.status.equals(MessageDeliveryStatus.received.index))
      ..where(messageStatusTable.masterPubkey.equals(currentUserMasterPubkey));

    return query.watch().map((rows) {
      return rows.length;
    });
  }

  Stream<Map<DateTime, List<EventMessage>>> getMessages({
    required String conversationId,
    required String currentUserMasterPubkey,
  }) {
    final query = select(conversationMessageTable).join([
      innerJoin(
        eventMessageTable,
        eventMessageTable.eventReference.equalsExp(conversationMessageTable.messageEventReference),
      ),
      innerJoin(
        messageStatusTable,
        messageStatusTable.messageEventReference.equalsExp(eventMessageTable.eventReference),
      ),
    ])
      ..where(conversationMessageTable.conversationId.equals(conversationId))
      ..where(messageStatusTable.status.isNotIn([MessageDeliveryStatus.deleted.index]))
      ..groupBy([eventMessageTable.eventReference])
      ..distinct;

    return query.watch().map((rows) {
      final groupedMessages = <DateTime, List<EventMessage>>{};

      for (final row in rows) {
        final eventMessage = row.readTable(eventMessageTable).toEventMessage();

        final dateKey = DateTime(
          eventMessage.publishedAt.year,
          eventMessage.publishedAt.month,
          eventMessage.publishedAt.day,
        );

        groupedMessages.putIfAbsent(dateKey, () => []).add(eventMessage);

        groupedMessages[dateKey]!.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      }

      return groupedMessages;
    });
  }

  Future<EventMessage> getEventMessage({required EventReference eventReference}) async {
    final message = await (select(eventMessageTable)
          ..where((table) => table.eventReference.equalsValue(eventReference)))
        .getSingle();

    return message.toEventMessage();
  }

  Future<void> removeMessages({
    required Ref ref,
    required List<EventReference> eventReferences,
    required EventMessage deleteRequest,
  }) async {
    await ref.read(eventMessageDaoProvider).add(deleteRequest);

    await (update(messageStatusTable)
          ..where((table) => table.messageEventReference.isInValues(eventReferences)))
        .write(
      const MessageStatusTableCompanion(
        status: Value(MessageDeliveryStatus.deleted),
      ),
    );
  }
}
