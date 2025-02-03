part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ConversationTableDao conversationTableDao(Ref ref) =>
    ConversationTableDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [ConversationTable, ChatMessageTable, EventMessageTable])
class ConversationTableDao extends DatabaseAccessor<ChatDatabase> with _$ConversationTableDaoMixin {
  ConversationTableDao(super.db);

  Future<String?> getById(String uuid) async {
    final result = await (select(conversationTable)
          ..where((tbl) => tbl.uuid.equals(uuid) & tbl.isDeleted.equals(false)))
        .getSingleOrNull();
    return result?.uuid;
  }

  Future<List<ConversationTableData>> get() async {
    return (select(conversationTable)..where((tbl) => tbl.isDeleted.equals(false))).get();
  }

  Future<void> add(List<ConversationTableCompanion> companions) async {
    await batch((b) {
      b.insertAll(
        conversationTable,
        companions,
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Stream<List<ConversationListItem>> watchAll() {
    final query = select(conversationTable).join([
      leftOuterJoin(
        chatMessageTable,
        chatMessageTable.conversationId.equalsExp(conversationTable.uuid),
      ),
      leftOuterJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(chatMessageTable.eventMessage),
      ),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ConversationListItem(
          uuid: row.readTable(conversationTable).uuid,
          type: row.readTable(conversationTable).type,
          isArchived: row.readTable(conversationTable).isArchived,
          latestMessage: row.readTableOrNull(eventMessageTable)?.toEventMessage(),
        );
      }).toList();
    });
  }

  Future<List<ConversationListItem>> getAll() async {
    final query = select(conversationTable).join([
      leftOuterJoin(
        chatMessageTable,
        chatMessageTable.conversationId.equalsExp(conversationTable.uuid),
      ),
      leftOuterJoin(
        eventMessageTable,
        eventMessageTable.id.equalsExp(chatMessageTable.eventMessage),
      ),
    ]);

    return query.get().then((rows) {
      return rows.map((row) {
        final conversation = row.readTable(conversationTable);
        final message = row.readTableOrNull(eventMessageTable);
        return ConversationListItem(
          uuid: conversation.uuid,
          type: conversation.type,
          isArchived: conversation.isArchived,
          latestMessage: message?.toEventMessage(),
        );
      }).toList();
    });
  }
}
