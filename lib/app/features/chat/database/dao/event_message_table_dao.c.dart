part of '../chat_database.c.dart';

@Riverpod(keepAlive: true)
EventMessageTableDao eventMessageTableDao(Ref ref) =>
    EventMessageTableDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(tables: [EventMessageTable])
class EventMessageTableDao extends DatabaseAccessor<ChatDatabase> with _$EventMessageTableDaoMixin {
  EventMessageTableDao(super.db);

  Future<void> add(List<EventMessage> events) async {
    await batch((batch) {
      batch.insertAll(
        db.eventMessageTable,
        events.map(EventMessageRowClass.fromEventMessage),
        mode: InsertMode.insertOrReplace,
      );
    });
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
