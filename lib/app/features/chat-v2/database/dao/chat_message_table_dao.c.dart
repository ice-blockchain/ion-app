// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ChatMessageTableDao chatMessageTableDao(Ref ref) =>
    ChatMessageTableDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [ChatMessageTable])
class ChatMessageTableDao extends DatabaseAccessor<ChatDatabase> with _$ChatMessageTableDaoMixin {
  ChatMessageTableDao(super.db);

  Stream<int> getUnreadMessagesCount(String conversationUUID) {
    final query = select(chatMessageTable)
      ..where((tbl) => tbl.conversationId.equals(conversationUUID))
      ..where((tbl) => tbl.isDeleted.equals(false))
      ..where((tbl) => tbl.readStatus.isNotValue(DeliveryStatus.isRead.index));

    return query.watch().map((rows) {
      return rows.length;
    });
  }
}
