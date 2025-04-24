// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

class ConversationMessageTable extends Table {
  late final conversationId = text().references(ConversationTable, #id)();
  late final eventMessageId = text().references(EventMessageTable, #id)();
  late final sharedId = text()();
  
  @override
  Set<Column<Object>> get primaryKey => {eventMessageId};
}
