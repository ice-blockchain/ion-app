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
    ReactionTable,
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
      ..where(messageStatusTable.status.equals(MessageDeliveryStatus.received.index))
      ..groupBy([messageStatusTable.messageEventReference]);

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
      ..where(messageStatusTable.status.equals(MessageDeliveryStatus.received.index))
      ..groupBy([messageStatusTable.messageEventReference]);

    return query.watch().map((rows) => rows.length);
  }

  Stream<int> getAllUnreadMessagesCount(
    String masterPubkey,
    List<String> mutedConversationIds,
  ) {
    final query = select(messageStatusTable).join([
      innerJoin(
        conversationMessageTable,
        conversationMessageTable.messageEventReference
            .equalsExp(messageStatusTable.messageEventReference),
      ),
      innerJoin(
        eventMessageTable,
        eventMessageTable.eventReference.equalsExp(messageStatusTable.messageEventReference),
      ),
    ])
      ..where(
        conversationMessageTable.conversationId.isNotIn(mutedConversationIds),
      )
      ..where(messageStatusTable.status.equals(MessageDeliveryStatus.received.index))
      ..where(messageStatusTable.masterPubkey.equals(masterPubkey))
      ..groupBy([eventMessageTable.masterPubkey]);

    return query.watch().map((rows) {
      return rows.length;
    });
  }

  Stream<Map<DateTime, List<EventMessage>>> getMessages(String conversationId) {
    // Listen only to changes in conversationMessageTable
    final query = select(conversationMessageTable)
      ..where((tbl) => tbl.conversationId.equals(conversationId));

    return query.watch().asyncMap((conversationMessages) async {
      // Get all event references from the conversation messages
      final eventReferences = conversationMessages.map((msg) => msg.messageEventReference).toList();

      if (eventReferences.isEmpty) {
        return <DateTime, List<EventMessage>>{};
      }

      // Fetch corresponding event messages and statuses
      final eventMessages = await (select(eventMessageTable)
            ..where((tbl) => tbl.eventReference.isInValues(eventReferences)))
          .get();

      final statuses = await (select(messageStatusTable)
            ..where(
              (tbl) =>
                  tbl.messageEventReference.isInValues(eventReferences) &
                  tbl.status.isNotIn([MessageDeliveryStatus.deleted.index]),
            ))
          .get();

      // Filter eventMessages by those that have a non-deleted status
      final validEventReferences = statuses.map((status) => status.messageEventReference).toSet();

      final filteredEventMessages =
          eventMessages.where((msg) => validEventReferences.contains(msg.eventReference)).toList();

      // Group by date
      final groupedMessages = <DateTime, List<EventMessage>>{};
      for (final eventMessage in filteredEventMessages) {
        final em = eventMessage.toEventMessage();
        final dateKey = DateTime(
          em.publishedAt.year,
          em.publishedAt.month,
          em.publishedAt.day,
        );
        groupedMessages.putIfAbsent(dateKey, () => []).add(em);
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

  Stream<EventMessage?> watchEventMessage({required EventReference eventReference}) {
    final query = select(eventMessageTable).join([
      innerJoin(
        messageStatusTable,
        messageStatusTable.messageEventReference.equalsExp(eventMessageTable.eventReference),
      ),
    ])
      ..where(messageStatusTable.status.isNotIn([MessageDeliveryStatus.deleted.index]))
      ..where(eventMessageTable.eventReference.equalsValue(eventReference))
      ..groupBy([eventMessageTable.eventReference])
      ..distinct;

    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      return row.readTable(eventMessageTable).toEventMessage();
    });
  }

  Future<void> removeMessages({
    required Ref ref,
    required List<EventReference> eventReferences,
    required EventMessage deleteRequest,
  }) async {
    await _removeExpiredMessages(ref, eventReferences);
    await (update(messageStatusTable)
          ..where((table) => table.messageEventReference.isInValues(eventReferences)))
        .write(
      const MessageStatusTableCompanion(
        status: Value(MessageDeliveryStatus.deleted),
      ),
    );
  }

  Future<void> _removeExpiredMessages(Ref ref, List<EventReference> eventReferences) async {
    final env = ref.read(envProvider.notifier);
    final expiration = env.get<int>(EnvVariable.GIFT_WRAP_EXPIRATION_HOURS);

    final expiredMessageEventReferences = await (select(eventMessageTable)
          ..where(
            (table) => table.createdAt
                .isSmallerThanValue(DateTime.now().subtract(Duration(hours: expiration))),
          )
          ..where((table) => table.eventReference.isInValues(eventReferences)))
        .map((e) => e.eventReference)
        .get();

    await batch((b) {
      b
        ..deleteWhere(
          eventMessageTable,
          (table) => table.eventReference.isInValues(expiredMessageEventReferences),
        )
        ..deleteWhere(
          messageStatusTable,
          (table) => table.messageEventReference.isInValues(expiredMessageEventReferences),
        )
        ..deleteWhere(
          conversationMessageTable,
          (table) => table.messageEventReference.isInValues(expiredMessageEventReferences),
        )
        ..deleteWhere(
          reactionTable,
          (table) => table.messageEventReference.isInValues(expiredMessageEventReferences),
        );
    });
  }
}
