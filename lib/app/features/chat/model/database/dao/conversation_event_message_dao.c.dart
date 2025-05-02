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

    final eventReference = ReplaceablePrivateDirectMessageEntity.fromEventMessage(event)
        .data
        .toReplaceableEventReference(event.pubkey);

    final existingEvent = await (select(db.eventMessageTable)
          ..where((table) {
            return table.eventReference.equalsValue(eventReference);
          }))
        .getSingleOrNull();

    // If the event already exists and its creation date is after the new event's creation date, do nothing
    if (existingEvent != null &&
        existingEvent.toEventMessage().createdAt.isAfter(event.createdAt)) {
      return;
    }

    final dbModel = event.toChatDbModel(eventReference);

    await into(db.eventMessageTable).insert(
      dbModel,
      mode: InsertMode.insertOrReplace,
    );

    if (eventReference.dTag != null) {
      await into(db.conversationMessageTable).insert(
        ConversationMessageTableCompanion(
          sharedId: Value(eventReference.dTag!),
          eventReferenceId: Value(eventReference),
          conversationId: Value(conversationId),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  /// Get the creation date of the most recent event messages of specific kinds
  /// Returns null if no messages of those kinds exist
  Future<DateTime?> getLatestEventMessageDate(List<int> kinds) async {
    final query = select(eventMessageTable)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..where((t) => t.kind.isIn(kinds))
      ..limit(1);

    final row = await query.getSingleOrNull();

    return row?.createdAt;
  }

  /// Get the creation date of the oldest event messages of specific kinds
  /// Returns null if no messages of those kinds exist
  Future<DateTime?> getEarliestEventMessageDate(List<int> kinds, {DateTime? after}) async {
    final query = select(eventMessageTable)..where((t) => t.kind.isIn(kinds));

    if (after != null) {
      query.where((t) => t.createdAt.isBiggerThanValue(after));
    }

    query
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();

    return row?.createdAt;
  }
}
