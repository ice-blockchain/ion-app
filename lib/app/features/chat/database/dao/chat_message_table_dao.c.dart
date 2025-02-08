// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ChatMessageTableDao chatMessageTableDao(Ref ref) =>
    ChatMessageTableDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [ChatMessageTable])
class ChatMessageTableDao extends DatabaseAccessor<ChatDatabase> with _$ChatMessageTableDaoMixin {
  ChatMessageTableDao(super.db);
  //TODO: integrate message_status table
  Stream<int> getUnreadMessagesCount(String conversationUUID) {
    final query = select(chatMessageTable)
      ..where((tbl) => tbl.conversationId.equals(conversationUUID))
      ..where((tbl) => tbl.isDeleted.equals(false));

    return query.watch().map((rows) {
      return rows.length;
    });
  }
}
