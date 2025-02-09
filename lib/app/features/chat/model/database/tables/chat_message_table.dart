// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

class ConversationMessageTable extends Table {
  late final conversationId = text().references(ConversationTable, #id)();
  late final eventMessageId = text().references(EventMessageTable, #id)();

  late final isDeleted = boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {eventMessageId};
}
