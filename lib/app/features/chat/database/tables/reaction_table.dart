part of '../chat_database.c.dart';

class ReactionTable extends Table {
  late final id = integer().autoIncrement()();

  late final message = text().references(ChatMessageTable, #id)();
  late final eventMessage = text().references(EventMessageTable, #id)();
}
