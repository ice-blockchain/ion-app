part of '../chat_database.c.dart';

class ConversationTable extends Table {
  late final uuid = text()();
  late final type = intEnum<ConversationType>()();

  late final isArchived = boolean().withDefault(const Constant(false))();
  late final isDeleted = boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {uuid};
}

enum ConversationType {
  e2ee,
  community,
}
