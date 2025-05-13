// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

class ConversationMessageTable extends Table {
  late final conversationId = text().references(ConversationTable, #id)();
  late final messageEventReference =
      text().map(const EventReferenceConverter()).references(EventMessageTable, #eventReference)();

  late final isDeleted = boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {messageEventReference};
}
