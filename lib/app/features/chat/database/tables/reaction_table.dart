part of '../chat_database.c.dart';

class ReactionTable extends Table {
  late final id = integer().autoIncrement()();
  late final isDeleted = boolean().withDefault(const Constant(false))();
  late final eventMessage = text().references(EventMessageTable, #id)();
}
