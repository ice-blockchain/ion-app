import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/community/models/entities/community_join_data.c.dart';
import 'package:ion/app/features/chat/community/models/entities/tags/community_identifer_tag.c.dart';
import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/conversation_list_item.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_db_repository.c.g.dart';

@Riverpod(keepAlive: true)
ConversationDbRepository conversationDbRepository(Ref ref) => ConversationDbRepository(
      ref.watch(conversationTableDaoProvider),
      ref.watch(eventMessageTableDaoProvider),
      ref.watch(chatMessageTableDaoProvider),
    );

class ConversationDbRepository {
  ConversationDbRepository(
    this.conversationTableDao,
    this.eventMessageTableDao,
    this.chatMessageTableDao,
  );

  final ConversationTableDao conversationTableDao;
  final EventMessageTableDao eventMessageTableDao;
  final ChatMessageTableDao chatMessageTableDao;

  Future<void> addConversation(List<EventMessage> events) async {
    final companions = events.map(
      (event) {
        final conversationType = event.kind == CommunityJoinEntity.kind
            ? ConversationType.community
            : ConversationType.e2ee;
        //extract it from tags by CommunityIdentifierTag
        final tags = groupBy(event.tags, (tag) => tag[0]);
        final communityIdentifierValue =
            tags[CommunityIdentifierTag.tagName]!.map(CommunityIdentifierTag.fromTag).first.value;

        return ConversationTableCompanion(
          uuid: Value(communityIdentifierValue),
          type: Value(conversationType),
        );
      },
    ).toList();

    await conversationTableDao.add(companions);
  }

  Stream<List<ConversationListItem>> watchConversations() {
    return conversationTableDao.watchAll();
    // .asyncMap((conversations) async {
    //   final results = <(ConversationTableData, EventMessageRowClass?)>[];
    //   for (final conversation in conversations) {
    //     final message = await eventMessageTableDao.getLatestOfCommunity(conversation.uuid);
    //     results.add((conversation, message));
    //   }
    //   return results;
    // });
  }

  Future<List<ConversationListItem>> getAll() async {
    return conversationTableDao.getAll();
  }
}
