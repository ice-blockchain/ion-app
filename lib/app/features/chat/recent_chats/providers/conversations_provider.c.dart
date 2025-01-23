// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/community/providers/communites_provider.c.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/ee2e_conversation_data.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/services/database/conversation_db_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_e2ee_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.c.g.dart';

@Riverpod(keepAlive: true)
class Conversations extends _$Conversations {
  @override
  FutureOr<List<E2eeConversationEntity>> build() async {
    final conversationSubscription = ref
        .read(conversationsDBServiceProvider)
        .watchConversations()
        .listen((conversationsEventMessages) async {
      final lastPrivateDirectMesssages =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

      final conversations = await Future.wait(lastPrivateDirectMesssages.map(_getConversationData));

      state = AsyncValue.data(conversations);
    });

    ref.onDispose(conversationSubscription.cancel);

    return await getConversations();
  }

  Future<List<E2eeConversationEntity>> getConversations() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final database = ref.read(conversationsDBServiceProvider);
      final conversationsEventMessages = await database.getAllConversations();

      final lastPrivateDirectMesssages =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

      final conversations = await Future.wait(lastPrivateDirectMesssages.map(_getConversationData));

      //TODO: remove this after we extend the conversation data to include channel data
      final joinedCommunities = await ref.read(communitesProvider.future);
      for (final community in joinedCommunities) {
        conversations.add(
          Ee2eConversationEntity(
            name: community.data.name,
            type: ChatType.channel,
            participants: [],
            lastMessageAt: DateTime.now(),
            lastMessageContent: 'channel created',
            imageUrl: community.data.avatar?.url,
            nickname: community.data.uuid,
          ),
        );
      }

      return conversations;
    });

    return state.requireValue;
  }

  Future<E2eeConversationEntity> _getConversationData(PrivateDirectMessageEntity message) async {
    var name = 'Unknown';
    String? nickname;
    String? imageUrl;

    final type = (message.data.relatedSubject != null) ? ChatType.group : ChatType.chat;

    if (type == ChatType.chat) {
      final userMetadata =
          await ref.read(userMetadataProvider(message.data.relatedPubkeys!.first.value).future);

      if (userMetadata != null) {
        nickname = userMetadata.data.name;
        name = userMetadata.data.displayName;
        imageUrl = userMetadata.data.picture ?? '';
      }
    } else {
      name = message.data.relatedSubject?.value ?? '';

      final conversationMessageManagementService =
          await ref.read(conversationMessageManagementServiceProvider);
      final imageUrls = await conversationMessageManagementService
          .downloadDecryptDecompressMedia([message.data.primaryMedia!]);
      imageUrl = imageUrls.first.path;
    }

    final lastMessageAt = message.createdAt;
    final participants =
        message.data.relatedPubkeys?.map((toElement) => toElement.value).toList() ?? [];
    final lastMessageContent = message.data.content.toString();

    final database = ref.read(conversationsDBServiceProvider);

    final conversationId = await database.lookupConversationByEventMessageId(message.id);

    final unreadMessagesCount =
        conversationId != null ? await database.getUnreadMessagesCount(conversationId) : null;

    final isArchived = await _checkConversationIsArchived(
      type: type,
      participants: participants,
      subject: message.data.relatedSubject?.value,
    );

    return E2eeConversationEntity(
      name: name,
      type: type,
      id: conversationId,
      nickname: nickname,
      imageUrl: imageUrl,
      isArchived: isArchived,
      participants: participants,
      lastMessageAt: lastMessageAt,
      lastMessageContent: lastMessageContent,
      unreadMessagesCount: unreadMessagesCount,
    );
  }

  Future<bool> _checkConversationIsArchived({
    required ChatType type,
    required List<String> participants,
    required String? subject,
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

      if (type == ChatType.chat &&
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
