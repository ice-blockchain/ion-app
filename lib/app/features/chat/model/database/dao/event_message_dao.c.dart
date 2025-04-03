// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
EventMessageDao eventMessageDao(Ref ref) => EventMessageDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(
  tables: [
    ReactionTable,
    ConversationTable,
    EventMessageTable,
    MessageStatusTable,
    ConversationMessageTable,
  ],
)
class EventMessageDao extends DatabaseAccessor<ChatDatabase> with _$EventMessageDaoMixin {
  EventMessageDao(super.db);

  Future<void> add(EventMessage event) async {
    await into(db.eventMessageTable)
        .insert(EventMessageRowClass.fromEventMessage(event), mode: InsertMode.insertOrReplace);
  }

  Future<List<EventMessage>> search(String query) async {
    if (query.isEmpty) return [];

    final searchResults =
        await (select(db.eventMessageTable)..where((tbl) => tbl.content.like('%$query%'))).get();

    return searchResults.map((row) => row.toEventMessage()).toList();
  }
}
