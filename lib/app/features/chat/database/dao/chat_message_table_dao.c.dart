part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
ChatMessageTableDao chatMessageTableDao(Ref ref) =>
    ChatMessageTableDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [ChatMessageTable])
class ChatMessageTableDao extends DatabaseAccessor<ChatDatabase> with _$ChatMessageTableDaoMixin {
  ChatMessageTableDao(super.db);
}
