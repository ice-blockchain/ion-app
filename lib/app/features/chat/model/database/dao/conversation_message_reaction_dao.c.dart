// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@riverpod
ConversationMessageReactionDao conversationMessageReactionDao(Ref ref) =>
    ConversationMessageReactionDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(
  tables: [ReactionTable, ConversationMessageTable, EventMessageTable],
)
class ConversationMessageReactionDao extends DatabaseAccessor<ChatDatabase>
    with _$ConversationMessageReactionDaoMixin {
  ConversationMessageReactionDao(super.db);

  Future<void> add({
    required Ref ref,
    required String masterPubkey,
    required String kind14SharedId,
    required EventMessage newReactionEvent,
  }) async {
    final entity = PrivateMessageReactionEntity.fromEventMessage(newReactionEvent);
    final eventMessageDao = ref.read(eventMessageDaoProvider);

    final existingReactionRow = await (select(reactionTable)
          ..where((table) => table.content.equals(newReactionEvent.content))
          ..where((table) => table.masterPubkey.equals(masterPubkey))
          ..where((table) => table.kind14SharedId.equals(kind14SharedId)))
        .getSingleOrNull();

    if (existingReactionRow == null) {
      await eventMessageDao.add(newReactionEvent);
      await into(reactionTable).insert(
        ReactionTableCompanion(
          id: Value(newReactionEvent.id),
          kind14SharedId: Value(kind14SharedId),
          masterPubkey: Value(masterPubkey),
          content: Value(newReactionEvent.content),
          sharedId: Value(entity.data.sharedId),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    } else {
      final previousReactionEvent = await (select(db.eventMessageTable)
            ..where((table) => table.id.equals(existingReactionRow.id)))
          .getSingleOrNull();

      await eventMessageDao.add(newReactionEvent);

      if (previousReactionEvent != null &&
          previousReactionEvent.createdAt.isBefore(newReactionEvent.createdAt)) {
        await (update(reactionTable)..where((table) => table.id.equals(existingReactionRow.id)))
            .write(
          ReactionTableCompanion(
            id: Value(newReactionEvent.id),
            isDeleted: const Value(false),
          ),
        );
      }
    }
  }

  Future<void> remove({
    required Ref ref,
    required String sharedId,
  }) async {
    await (update(reactionTable)..where((table) => table.sharedId.equals(sharedId))).write(
      const ReactionTableCompanion(isDeleted: Value(true)),
    );
  }

  Stream<List<MessageReactionGroup>> messageReactions(EventMessage kind14EventMessage) async* {
    final existingRows = (select(reactionTable)
          ..where((table) => table.isDeleted.equals(false))
          ..where((table) => table.kind14SharedId.equals(kind14EventMessage.sharedId!)))
        .watch();

    yield* existingRows.asyncMap((rows) async {
      final groupedReactions = <String, List<EventMessage>>{};

      for (final row in rows) {
        final eventMessageDataRow = await (select(db.eventMessageTable)
              ..where((table) => table.id.equals(row.id)))
            .getSingleOrNull();

        if (eventMessageDataRow != null) {
          if (!groupedReactions.containsKey(row.content)) {
            groupedReactions[row.content] = [];
          }
          groupedReactions[row.content]!.add(eventMessageDataRow.toEventMessage());
        }
      }

      return groupedReactions.entries.map((entry) {
        return MessageReactionGroup(
          emoji: entry.key,
          eventMessages: entry.value,
        );
      }).toList();
    });
  }

  Stream<String?> storyReaction(String? kind14SharedId) async* {
    if (kind14SharedId == null) {
      yield null;
      return;
    }

    final stream = (select(reactionTable)
          ..where((table) => table.isDeleted.equals(false))
          ..where((table) => table.kind14SharedId.equals(kind14SharedId)))
        .watchSingleOrNull()
        .map((row) => row?.content);

    await for (final value in stream) {
      yield value;
    }
  }
}
