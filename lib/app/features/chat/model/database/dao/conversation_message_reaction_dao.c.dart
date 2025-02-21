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
    log('BBB1');
    final existingRow = await (select(reactionTable)
          ..where((table) => table.masterPubkey.equals(masterPubkey))
          ..where((table) => table.eventMessageId.equals(eventMessageId)))
        .getSingleOrNull();
    log('BBB2');

    if (existingRow == null) {
      await into(reactionTable).insert(
        ReactionTableCompanion(
          content: Value(content),
          masterPubkey: Value(masterPubkey),
          eventMessageId: Value(eventMessageId),
        ),
        mode: InsertMode.insertOrIgnore,
      );
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
    final existingRows = select(reactionTable)
      ..where((table) => table.isDeleted.equals(false))
      ..where((table) => table.eventMessageId.equals(entity.id));

    yield <MessageReactionGroup>[
      MessageReactionGroup(
        emoji: '\u{1f44c}',
        pubkeys: entity.data.relatedPubkeys.emptyOrValue.map((e) => e.value).toList(),
      ),
    ];
  }
}
