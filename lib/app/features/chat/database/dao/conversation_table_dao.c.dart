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
        eventMessageTable.id.equalsExp(chatMessageTable.eventMessageId),
      ),
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

  Future<List<ConversationListItem>> getAll() async {
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
      ..groupBy([
        conversationTable.uuid,
      ])
      ..distinct;

    return query.get().then((rows) {
      final sortedRows = rows
          .sortedBy(
        (e) =>
            e.readTableOrNull(eventMessageTable)?.createdAt ??
            e.readTable(conversationTable).joinedAt,
      )
          .map((row) {
        final conversation = row.readTable(conversationTable);
        final message = row.readTableOrNull(eventMessageTable);
        return ConversationListItem(
          uuid: conversation.uuid,
          type: conversation.type,
          isArchived: conversation.isArchived,
          joinedAt: conversation.joinedAt,
          latestMessage: message?.toEventMessage(),
        );
      }).toList();

      return sortedRows.reversed.toList();
    });
  }
}
