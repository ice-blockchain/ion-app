// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/database/conversation_db_service.c.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/conversation_data.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_e2ee_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.c.g.dart';

@Riverpod(keepAlive: true)
class Conversations extends _$Conversations {
  @override
  FutureOr<List<ConversationEntity>> build() async {
    final conversationSubscription = ref
        .read(conversationsDBServiceProvider)
        .watchConversations()
        .listen((conversationsMessages) async {
      final conversations = await Future.wait(
        conversationsMessages.map(_getConversationData),
      );

      state = AsyncValue.data(
        (conversations..sortBy<DateTime>((e) => e.lastMessageAt!)).reversed.toList(),
      );
    });

    ref.onDispose(conversationSubscription.cancel);

    return await getConversations();
  }

  Future<List<ConversationEntity>> getConversations() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final database = ref.read(conversationsDBServiceProvider);

      final conversationsMessages = await database.getAllConversations();

      final conversations = await Future.wait(
        conversationsMessages.map(_getConversationData),
      );

      return (conversations..sortBy<DateTime>((e) => e.lastMessageAt!)).reversed.toList();
    });

    return state.requireValue;
  }

  Future<ConversationEntity> _getConversationData(PrivateDirectMessageEntity message) async {
    final imageUrl = message.data.relatedGroupImagePath;
    final name = message.data.relatedSubject?.value ?? '';
    final conversationId = message.data.relatedConversationId?.value;
    final type = (message.data.relatedSubject != null) ? ChatType.group : ChatType.oneOnOne;
    final participantsMasterkeys =
        message.data.relatedPubkeys?.map((toElement) => toElement.value).toList() ?? [];

    final lastMessageAt = message.createdAt;
    final lastMessageContent = message.data.content.map((m) => m.text).join();

    final isArchived = await _checkConversationIsArchived(
      type: type,
      participants: participantsMasterkeys,
      subject: message.data.relatedSubject?.value,
    );

    if (conversationId == null) {
      throw ConversationIsNotFoundException(message.id);
    }

    return ConversationEntity(
      name: name,
      type: type,
      imageUrl: imageUrl,
      id: conversationId,
      isArchived: isArchived,
      lastMessageAt: lastMessageAt,
      lastMessageContent: lastMessageContent,
      participantsMasterkeys: participantsMasterkeys,
    );
  }

  Future<bool> _checkConversationIsArchived({
    required ChatType type,
    required String? subject,
    required List<String> participants,
  }) async {
    final currentPubkey = await ref.read(currentPubkeySelectorProvider.future);
    final e2eeService = await ref.read(ionConnectE2eeServiceProvider.future);

    final bookmarksMap = await ref.read(currentUserBookmarksProvider.future);

    final archivedChatsBookmarksSet = bookmarksMap[BookmarksSetType.chats];

    final currentUserPubkey = await ref.read(currentPubkeySelectorProvider.future);
    if (currentUserPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    var archivedConversations = <List<String>>[];

    if (archivedChatsBookmarksSet != null) {
      final decryptedContent =
          await e2eeService.decryptMessage(archivedChatsBookmarksSet.data.content);

      archivedConversations = (jsonDecode(decryptedContent) as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList();
    }

    for (final archivedConversation in archivedConversations) {
      final filteredParticipants = List<String>.from(participants).where((e) => e != currentPubkey);

      if (type == ChatType.oneOnOne &&
          archivedConversation.contains('p') &&
          archivedConversation[1] == filteredParticipants.single) {
        return true;
      } else if (type == ChatType.group && archivedConversation.contains('subject')) {
        final archivedSubject = archivedConversation[1];
        final archivedParticipants = archivedConversation.sublist(2);

        if (archivedSubject == subject &&
            archivedParticipants.toSet().containsAll(participants.toSet())) {
          return true;
        }
      }
    }

    return false;
  }
}
