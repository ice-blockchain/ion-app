part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationTableDao conversationTableDao(Ref ref) =>
    ConversationTableDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [ConversationTable, ChatMessageTable, EventMessageTable])
class ConversationTableDao extends DatabaseAccessor<ChatDatabase> with _$ConversationTableDaoMixin {
  ConversationTableDao(super.db);

  Future<void> add(List<EventMessage> events) async {
    final companions = events.map(
      (event) {
        final tags = groupBy(event.tags, (tag) => tag[0]);
        final communityIdentifierValue =
            tags[CommunityIdentifierTag.tagName]!.map(CommunityIdentifierTag.fromTag).first.value;
        final subject = tags[RelatedSubject.tagName]?.map(RelatedSubject.fromTag).firstOrNull;

        final conversationType = event.kind == CommunityJoinEntity.kind
            ? ConversationType.community
            : subject == null
                ? ConversationType.oneToOne
                : ConversationType.encryptedGroup;

        return ConversationTableCompanion(
          uuid: Value(communityIdentifierValue),
          type: Value(conversationType),
          joinedAt: Value(event.createdAt),
        );
      },
    ).toList();

    await batch((b) {
      b.insertAll(
        conversationTable,
        companions,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Stream<List<ConversationListItem>> watch() {
    final query = select(conversationTable).join([
      leftOuterJoin(
        chatMessageTable,
        chatMessageTable.conversationId.equalsExp(conversationTable.uuid),
      ),
      leftOuterJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(chatMessageTable.eventMessageId),
      ),
    ])
      ..addColumns([
        eventMessageTable.createdAt.max(),
      ])
      ..groupBy([
        conversationTable.uuid,
      ])
      ..distinct;

    return query.watch().map((rows) {
      final sortedRows = rows
          .sortedBy(
        (e) =>
            e.readTableOrNull(eventMessageTable)?.createdAt ??
            e.readTable(conversationTable).joinedAt,
      )
          .map((row) {
        return ConversationListItem(
          uuid: row.readTable(conversationTable).uuid,
          type: row.readTable(conversationTable).type,
          isArchived: row.readTable(conversationTable).isArchived,
          joinedAt: row.readTable(conversationTable).joinedAt,
          latestMessage: row.readTableOrNull(eventMessageTable)?.toEventMessage(),
        );
      }).toList();

      return sortedRows.reversed.toList();
    });
  }

  Future<List<String>> getParticipants(String uuid) async {
    final query = select(chatMessageTable).join([
      innerJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(chatMessageTable.eventMessageId),
      ),
    ])
      ..where(chatMessageTable.conversationId.equals(uuid))
      ..orderBy([OrderingTerm.desc(eventMessageTable.createdAt)])
      ..limit(1);

    final row = await query.getSingle();

    final eventMessage = row.readTable(eventMessageTable).toEventMessage();

    final entity = PrivateDirectMessageEntity.fromEventMessage(eventMessage);

    return entity.allPubkeys;
  }

  Future<String> getSubject(String uuid) async {
    final query = select(chatMessageTable).join([
      innerJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(chatMessageTable.eventMessageId),
      ),
    ])
      ..where(chatMessageTable.conversationId.equals(uuid))
      ..orderBy([OrderingTerm.desc(eventMessageTable.createdAt)])
      ..limit(1);

    final row = await query.getSingle();

    final eventMessage = row.readTable(eventMessageTable).toEventMessage();

    final entity = PrivateDirectMessageEntity.fromEventMessage(eventMessage);

    return entity.data.relatedSubject?.value ?? '';
  }

  Future<String?> getExistingOneToOneConversation(String receiverPubKey) async {
    final query = select(conversationTable).join([
      innerJoin(
        chatMessageTable,
        chatMessageTable.conversationId.equalsExp(conversationTable.uuid),
      ),
      innerJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(chatMessageTable.eventMessageId),
      ),
    ])
      ..where(
        eventMessageTable.tags.contains(receiverPubKey),
      )
      ..where(eventMessageTable.kind.equals(PrivateDirectMessageEntity.kind))
      ..where(conversationTable.type.equals(ConversationType.oneToOne.index))
      ..where(conversationTable.isDeleted.equals(false))
      ..where(chatMessageTable.isDeleted.equals(false))
      ..orderBy([OrderingTerm.desc(eventMessageTable.createdAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    return row.readTable(conversationTable).uuid;
  }

  //get commuunity's event messages byb grouping to the day
  Stream<Map<DateTime, List<EventMessage>>> getMessages(String uuid) {
    final query = select(conversationTable).join([
      innerJoin(
        chatMessageTable,
        chatMessageTable.conversationId.equalsExp(conversationTable.uuid),
      ),
      innerJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(chatMessageTable.eventMessageId),
      ),
    ])
      ..where(conversationTable.uuid.equals(uuid))
      ..where(chatMessageTable.isDeleted.equals(false));

    return query.watch().map((rows) {
      // Group messages by date
      final groupedMessages = <DateTime, List<EventMessage>>{};

      for (final row in rows) {
        final eventMessage = row.readTable(eventMessageTable).toEventMessage();

        // Extract only the date part (ignoring time)
        final dateKey = DateTime(
          eventMessage.createdAt.year,
          eventMessage.createdAt.month,
          eventMessage.createdAt.day,
        );

        // Add message to corresponding date group
        groupedMessages.putIfAbsent(dateKey, () => []).add(eventMessage);
      }

      return groupedMessages;
    });
  }
}
