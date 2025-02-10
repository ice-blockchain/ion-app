// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationMessageDao conversationMessageDao(Ref ref) =>
    ConversationMessageDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [ConversationMessageTable, EventMessageTable])
class ConversationMessageDao extends DatabaseAccessor<ChatDatabase>
    with _$ConversationMessageDaoMixin {
  ConversationMessageDao(super.db);

  /// Get a stream of the count of unread messages for a conversation
  ///
  /// Takes a [conversationId] and returns a [Stream] of integers representing
  /// the count of unread messages in that conversation.
  ///
  /// Only counts non-deleted messages in the specified conversation.
  /// TODO: integrate message_status table to properly track read/unread status
  Stream<int> getUnreadMessagesCount(String conversationId) {
    final query = select(conversationMessageTable)
      ..where((tbl) => tbl.conversationId.equals(conversationId));

    return query.watch().map((rows) {
      return rows.length;
    });
  }

  /// Get a stream of messages for a conversation
  ///
  /// Takes a [conversationId] and returns a [Stream] of [EventMessage] objects
  /// representing the messages in that conversation.
  ///
  /// Only includes non-deleted messages in the specified conversation.
  Stream<Map<DateTime, List<EventMessage>>> getMessages(String conversationId) {
    final query = select(conversationMessageTable).join([
      innerJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(conversationMessageTable.eventMessageId),
      ),
    ])
      ..where(conversationMessageTable.conversationId.equals(conversationId))
      ..orderBy([
        OrderingTerm.asc(eventMessageTable.createdAt),
      ]);

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
}
