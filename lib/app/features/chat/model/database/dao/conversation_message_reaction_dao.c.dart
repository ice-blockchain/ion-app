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
    required EventMessage reactionEvent,
  }) async {
    final reactionEntity = PrivateMessageReactionEntity.fromEventMessage(reactionEvent);
    final eventMessageDao = ref.read(eventMessageDaoProvider);

    await eventMessageDao.add(reactionEvent);
    await into(reactionTable).insert(
      ReactionTableCompanion.insert(
        reactionEventReference: reactionEntity.toEventReference(),
        messageEventReference: reactionEntity.data.reference,
        masterPubkey: reactionEntity.masterPubkey,
        content: reactionEntity.data.content,
      ),
      mode: InsertMode.insertOrIgnore,
    );

    return;

    // if (existingReactionRow == null) {
    //   await eventMessageDao.add(reactionEvent);
    //   await into(reactionTable).insert(
    //     ReactionTableCompanion.insert(
    //       reactionEventReference: reactionEntity.toEventReference(),
    //       messageEventReference: reactionEntity.data.reference,
    //       masterPubkey: masterPubkey,
    //       content: reactionEntity.data.content,
    //     ),
    //     mode: InsertMode.insertOrIgnore,
    //   );
    // } else {
    //   final previousReactionEvent = await (select(db.eventMessageTable)
    //         ..where(
    //           (table) =>
    //               table.eventReference.equalsValue(existingReactionRow.messageEventReference),
    //         ))
    //       .getSingleOrNull();

    //   await eventMessageDao.add(newReactionEvent);

    //   if (previousReactionEvent != null &&
    //       previousReactionEvent.createdAt.isBefore(newReactionEvent.createdAt)) {
    //     await (update(reactionTable)
    //           ..where(
    //             (table) => table.messageEventReference
    //                 .equalsValue(existingReactionRow.messageEventReference),
    //           ))
    //         .write(
    //       const ReactionTableCompanion(
    //         isDeleted: Value(false),
    //       ),
    //     );
    //   }
    // }
  }

  Future<void> remove({
    required Ref ref,
    required ImmutableEventReference reactionEventReference,
  }) async {
    await (update(reactionTable)
          ..where((table) => table.reactionEventReference.equalsValue(reactionEventReference)))
        .write(
      const ReactionTableCompanion(isDeleted: Value(true)),
    );
  }

  Stream<List<MessageReactionGroup>> messageReactions(EventMessage kind14EventMessage) async* {
    final eventReference =
        ReplaceablePrivateDirectMessageEntity.fromEventMessage(kind14EventMessage)
            .toEventReference();

    final existingRows = (select(reactionTable)
          ..where((table) => table.isDeleted.equals(false))
          ..where((table) => table.messageEventReference.equalsValue(eventReference)))
        .watch();

    yield* existingRows.asyncMap((rows) async {
      final groupedReactions = <String, List<EventMessage>>{};

      for (final row in rows) {
        final eventMessageDataRow = await (select(db.eventMessageTable)
              ..where((table) => table.eventReference.equalsValue(row.reactionEventReference)))
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

  Future<bool> isReactionExist({
    required EventReference messageEventReference,
    required String emoji,
    required String masterPubkey,
  }) async {
    final row = await (select(reactionTable)
          ..where((table) => table.isDeleted.equals(false))
          ..where((table) => table.messageEventReference.equalsValue(messageEventReference))
          ..where((table) => table.content.equals(emoji))
          ..where((table) => table.masterPubkey.equals(masterPubkey)))
        .get();

    return row.isNotEmpty;
  }

  Stream<String?> storyReaction(EventReference? eventReference) async* {
    if (eventReference == null) {
      yield null;
      return;
    }

    //TODO: refactor it to work with multiple reactions
    final stream = (select(reactionTable)
          ..where((table) => table.isDeleted.equals(false))
          ..where((table) => table.messageEventReference.equalsValue(eventReference)))
        .watchSingleOrNull()
        .map((row) => row?.content);

    await for (final value in stream) {
      yield value;
    }
  }
}
