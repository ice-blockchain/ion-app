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
        eventMessageTable.sharedId.equalsExp(conversationMessageTable.sharedId),
      ),
      innerJoin(
        messageStatusTable,
        messageStatusTable.sharedId.equalsExp(conversationMessageTable.sharedId),
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
        conversationMessageTable.sharedId.equalsExp(messageStatusTable.sharedId),
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
        eventMessageTable,
        eventMessageTable.sharedId.equalsExp(messageStatusTable.sharedId),
      ),
      innerJoin(
        conversationMessageTable,
        conversationMessageTable.eventMessageId.equalsExp(eventMessageTable.id),
      ),
    ])
      ..where(
        conversationMessageTable.conversationId.isNotIn(mutedConversationIds),
      )
      ..where(messageStatusTable.status.equals(MessageDeliveryStatus.received.index))
      ..where(messageStatusTable.masterPubkey.equals(currentUserMasterPubkey));

    return query.watch().map((rows) => rows.length);
  }

  Stream<Map<DateTime, List<EventMessage>>> getMessages({
    required String conversationId,
    required String currentUserMasterPubkey,
  }) {
    final query = select(conversationMessageTable).join([
      innerJoin(
        eventMessageTable,
        eventMessageTable.sharedId.equalsExp(conversationMessageTable.sharedId),
      ),
      innerJoin(
        messageStatusTable,
        messageStatusTable.sharedId.equalsExp(conversationMessageTable.sharedId),
      ),
    ])
      ..where(conversationMessageTable.conversationId.equals(conversationId))
      ..where(messageStatusTable.masterPubkey.equals(currentUserMasterPubkey))
      ..where(messageStatusTable.status.isNotIn([MessageDeliveryStatus.deleted.index]))
      ..orderBy([OrderingTerm.desc(eventMessageTable.createdAt)])
      ..groupBy([eventMessageTable.sharedId])
      ..addColumns([eventMessageTable.createdAt.max()]);

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

  Future<EventMessage> getEventMessage(String sharedId) async {
    final message = await (select(eventMessageTable)
          ..where((table) => table.sharedId.equals(sharedId))
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(1))
        .getSingle();

    return message.toEventMessage();
  }

  Future<void> removeMessages({
    required Ref ref,
    required List<String> sharedIds,
    required EventMessage deleteRequest,
  }) async {
    await ref.read(eventMessageDaoProvider).add(deleteRequest);

    await (update(messageStatusTable)..where((table) => table.sharedId.isIn(sharedIds))).write(
      const MessageStatusTableCompanion(
        status: Value(MessageDeliveryStatus.deleted),
      ),
    );
  }
}
