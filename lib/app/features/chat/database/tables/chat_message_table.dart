part of '../chat_database.c.dart';

class ChatMessageTable extends Table {
  late final id = integer().autoIncrement()();

  late final conversationId = text().references(ConversationTable, #uuid)();
  late final eventMessageId = text().references(EventMessageTable, #id)();

  late final isDeleted = boolean().withDefault(const Constant(false))();
}
