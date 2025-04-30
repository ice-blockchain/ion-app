// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

class ConversationMessageTable extends Table {
  late final conversationId = text().references(ConversationTable, #id)();
  late final eventReferenceId =
      text().map(const EventReferenceConverter()).references(EventMessageTable, #eventReference)();
  late final sharedId = text()();

  @override
  Set<Column<Object>> get primaryKey => {eventReferenceId};
}
