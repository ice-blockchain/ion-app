part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
EventMessageTableDao eventMessageTableDao(Ref ref) =>
    EventMessageTableDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [EventMessageTable])
class EventMessageTableDao extends DatabaseAccessor<ChatDatabase> with _$EventMessageTableDaoMixin {
  EventMessageTableDao(super.db);

  Future<void> add(EventMessage event) async {
    await into(db.eventMessageTable).insert(EventMessageRowClass.fromEventMessage(event));

    final conversationId =
        event.tags.firstWhere((tag) => tag[0] == CommunityIdentifierTag.tagName).last;

    await into(db.chatMessageTable).insert(
      ChatMessageTableCompanion(
        conversationId: Value(conversationId),
        eventMessageId: Value(event.id),
      ),
    );
  }

  // Future<EventMessageRowClass?> getLatestOfCommunity(String communityId) async {
  //   final result = await (select(db.eventMessageTable)
  //         ..where(
  //           (tbl) => tbl.tags.contains([CommunityIdentifierTag.tagName, communityId] as String),
  //         )
  //         ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
  //       .getSingleOrNull();

  //   return result;
  // }
}
