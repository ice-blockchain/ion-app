part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
EventMessageTableDao eventMessageTableDao(Ref ref) =>
    EventMessageTableDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [EventMessageTable, ChatMessageTable])
class EventMessageTableDao extends DatabaseAccessor<ChatDatabase> with _$EventMessageTableDaoMixin {
  EventMessageTableDao(super.db);

  Future<void> add(EventMessage event) async {
    final conversationId =
        event.tags.firstWhere((tag) => tag[0] == CommunityIdentifierTag.tagName).lastOrNull;

    if (conversationId == null) {
      return;
    }

    await into(db.eventMessageTable).insert(EventMessageRowClass.fromEventMessage(event));

    await into(db.chatMessageTable).insert(
      ChatMessageTableCompanion(
        conversationId: Value(conversationId),
        eventMessageId: Value(event.id),
        readStatus: const Value(DeliveryStatus.isReceived),
      ),
    );
  }
}
