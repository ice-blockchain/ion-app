// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationDao conversationDao(Ref ref) => ConversationDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [ConversationTable, ConversationMessageTable, EventMessageTable])
class ConversationDao extends DatabaseAccessor<ChatDatabase> with _$ConversationDaoMixin {
  ConversationDao(super.db);

  ///
  /// Adds events to database and creates conversations
  ///
  /// Creates conversations from [EventMessage] list by extracting tags,
  /// setting type, and batch inserting into conversation table
  ///
  /// Skips events without community ID. Uses insertOrIgnore mode.
  ///
  Future<void> add(List<EventMessage> events) async {
    final companions = events.map(
      (event) {
        final tags = groupBy(event.tags, (tag) => tag[0]);
        final communityIdentifierValue = tags[CommunityIdentifierTag.tagName]
            ?.map(CommunityIdentifierTag.fromTag)
            .firstOrNull
            ?.value;
        final subject = tags[RelatedSubject.tagName]?.map(RelatedSubject.fromTag).firstOrNull;

        if (communityIdentifierValue == null) {
          return null;
        }

        final conversationType = event.kind == CommunityJoinEntity.kind
            ? ConversationType.community
            : subject == null
                ? ConversationType.oneToOne
                : ConversationType.group;

        return ConversationTableCompanion(
          id: Value(communityIdentifierValue),
          type: Value(conversationType),
          joinedAt: Value(event.createdAt),
        );
      },
    ).toList();

    await batch((b) {
      b.insertAll(
        conversationTable,
        companions.nonNulls,
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  /// Watch the list of conversations sorted by latest activity
  ///
  /// Returns a stream of [ConversationListItem] sorted by:
  /// - Latest message date if conversation has messages
  /// - Join date if conversation has no messages
  ///
  /// The list is sorted in descending order (newest first)
  ///
  Stream<List<ConversationListItem>> watch() {
    final query = select(conversationTable).join([
      leftOuterJoin(
        conversationMessageTable,
        conversationMessageTable.conversationId.equalsExp(conversationTable.id),
      ),
      leftOuterJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(conversationMessageTable.eventMessageId),
      ),
    ])
      ..addColumns([
        eventMessageTable.createdAt.max(),
      ])
      ..groupBy([
        conversationTable.id,
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
          conversationId: row.readTable(conversationTable).id,
          type: row.readTable(conversationTable).type,
          isArchived: row.readTable(conversationTable).isArchived,
          joinedAt: row.readTable(conversationTable).joinedAt,
          latestMessage: row.readTableOrNull(eventMessageTable)?.toEventMessage(),
        );
      }).toList();

      return sortedRows.reversed.toList();
    });
  }

  ///
  /// Get the id of the conversation with the given receiver master pubkey
  /// Only searches for non-deleted conversations of type [ConversationType.oneToOne]
  ///
  Future<String?> getExistOnetOneConversationId(String receiverMasterPubkey) async {
    final query = select(conversationTable).join([
      innerJoin(
        conversationMessageTable,
        conversationMessageTable.conversationId.equalsExp(conversationTable.id),
      ),
      innerJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(conversationMessageTable.eventMessageId),
      ),
    ])
      ..where(conversationTable.type.equals(ConversationType.oneToOne.index))
      ..where(conversationTable.isDeleted.equals(false))
      ..where(eventMessageTable.tags.contains(receiverMasterPubkey))
      ..where(eventMessageTable.kind.equals(PrivateDirectMessageEntity.kind))
      ..where(conversationMessageTable.isDeleted.equals(false))
      ..orderBy([OrderingTerm.desc(eventMessageTable.createdAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    return row.readTable(conversationTable).id;
  }

  /// Set the archived status of a conversation
  ///
  /// Takes a conversation [conversationId] and an optional [isArchived] boolean parameter
  /// Updates the conversation's archived status in the database.
  ///
  Future<void> setArchived(String conversationId, {bool isArchived = true}) async {
    await (update(conversationTable)..where((t) => t.id.equals(conversationId)))
        .write(ConversationTableCompanion(isArchived: Value(isArchived)));
  }

  /// Update the archived status of a list of conversations
  ///
  /// Takes a list of [archivedConversationIds] and updates the archived status of all conversations.
  /// Conversations with IDs in the list will be marked as archived (isArchived = true).
  /// All other conversations will be marked as not archived (isArchived = false).
  ///
  Future<void> updateArchivedConversations(List<String> archivedConversationIds) async {
    await batch((b) {
      b
        ..update(
          conversationTable,
          const ConversationTableCompanion(isArchived: Value(true)),
          where: (t) => t.id.isIn(archivedConversationIds),
        )
        ..update(
          conversationTable,
          const ConversationTableCompanion(isArchived: Value(false)),
          where: (t) => t.id.isNotIn(archivedConversationIds),
        );
    });
  }
}
