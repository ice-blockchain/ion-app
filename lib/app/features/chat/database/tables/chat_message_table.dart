part of '../chat_database.c.dart';

class ChatMessageTable extends Table {
  late final id = integer().autoIncrement()();

  late final conversationId = text().references(ConversationTable, #id)();
  late final eventMessage = text().references(EventMessageTable, #id)();

  late final isDeleted = boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
