// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationEventMessageDao conversationEventMessageDao(Ref ref) =>
    ConversationEventMessageDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(
  tables: [
    EventMessageTable,
    ConversationMessageTable,
  ],
)
class ConversationEventMessageDao extends DatabaseAccessor<ChatDatabase>
    with _$ConversationEventMessageDaoMixin {
  ConversationEventMessageDao(super.db);

  /// Add an event message to the database and associate it with a conversation
  ///
  /// Takes an [EventMessage] and extracts the conversation ID from its tags.
  /// If a valid conversation ID is found:
  /// 1. Inserts/replaces the event message in the event_message table
  /// 2. Creates a mapping in the chat_message table between the conversation and event message
  ///
  /// The chat_message mapping is only inserted if it doesn't already exist.
  Future<void> add(EventMessage event) async {
    final conversationId =
        event.tags.firstWhere((tag) => tag[0] == ConversationIdentifier.tagName).lastOrNull;

    if (conversationId == null) {
      return;
    }

    await into(db.eventMessageTable)
        .insert(EventMessageRowClass.fromEventMessage(event), mode: InsertMode.insertOrReplace);

    await into(db.conversationMessageTable).insert(
      ConversationMessageTableCompanion(
        conversationId: Value(conversationId),
        eventMessageId: Value(event.id),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  ///
  /// Get the creation date of the most recent event message of a specific kind
  /// Returns null if no messages of that kind exist
  ///
  Future<DateTime?> getLatestEventMessageDate(int kind) async {
    final query = select(eventMessageTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..where((t) => t.kind.equals(kind))
      ..limit(1);

    final row = await query.getSingleOrNull();

    return row?.createdAt;
  }
}
