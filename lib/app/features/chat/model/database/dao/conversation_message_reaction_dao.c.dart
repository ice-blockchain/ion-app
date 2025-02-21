// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

@riverpod
ConversationMessageReactionDao conversationMessageReactionDao(Ref ref) =>
    ConversationMessageReactionDao(ref.watch(chatDatabaseProvider));

@DriftAccessor(
  tables: [ReactionTable],
)
class ConversationMessageReactionDao extends DatabaseAccessor<ChatDatabase>
    with _$ConversationMessageReactionDaoMixin {
  ConversationMessageReactionDao(super.db);

  Future<void> add({
    required String content,
    required String masterPubkey,
    required String eventMessageId,
  }) async {
    final eventMessageExists = await (select(db.eventMessageTable)
          ..where((table) => table.id.equals(eventMessageId)))
        .getSingleOrNull();

    if (eventMessageExists == null) return;

    final existingRows = await (select(reactionTable)
          ..where((table) => table.masterPubkey.equals(masterPubkey))
          ..where((table) => table.eventMessageId.equals(eventMessageId)))
        .get();

    if (existingRows.isEmpty || existingRows.every((row) => row.content != content)) {
      await into(reactionTable).insert(
        ReactionTableCompanion(
          content: Value(content),
          masterPubkey: Value(masterPubkey),
          eventMessageId: Value(eventMessageId),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    } else if (existingRows.any((row) => row.content == content && row.isDeleted)) {
      await (update(reactionTable)
            ..where((table) => table.masterPubkey.equals(masterPubkey))
            ..where((table) => table.eventMessageId.equals(eventMessageId))
            ..where((table) => table.content.equals(content)))
          .write(const ReactionTableCompanion(isDeleted: Value(false)));
    }
  }

  Future<void> remove({
    required String content,
    required String masterPubkey,
    required String eventMessageId,
  }) async {
    final existingRow = await (select(db.reactionTable)
          ..where((table) => table.content.equals(content))
          ..where((table) => table.masterPubkey.equals(masterPubkey))
          ..where((table) => table.eventMessageId.equals(eventMessageId)))
        .getSingleOrNull();

    if (existingRow == null) return;

    await (update(reactionTable)..where((table) => table.id.equals(existingRow.id))).write(
      const ReactionTableCompanion(isDeleted: Value(true)),
    );
  }

  Stream<List<MessageReactionGroup>> messageReactions(PrivateDirectMessageEntity entity) async* {
    final existingRows = (select(reactionTable)
          ..where((table) => table.isDeleted.equals(false))
          ..where((table) => table.eventMessageId.equals(entity.id)))
        .watch();

    yield* existingRows.map((rows) {
      final groupedReactions = <String, List<String>>{};

      for (final row in rows) {
        if (!groupedReactions.containsKey(row.content)) {
          groupedReactions[row.content] = [];
        }
        groupedReactions[row.content]!.add(row.masterPubkey);
      }

      return groupedReactions.entries.map((entry) {
        return MessageReactionGroup(
          emoji: entry.key,
          pubkeys: entry.value,
        );
      }).toList();
    });
  }
}
