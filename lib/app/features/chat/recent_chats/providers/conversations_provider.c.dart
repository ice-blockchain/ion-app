// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/ee2e_conversation_data.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/chat/database/conversation_db_service.c.dart';
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
        .listen((conversationsMessages) async {
      final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

      if (eventSigner == null) {
        throw EventSignerNotFoundException();
      }

      final conversations = await Future.wait(
        conversationsMessages
            .map((message) => _getConversationData(message, eventSigner.publicKey)),
      );

      state = AsyncValue.data(
        (conversations..sortBy<DateTime>((e) => e.lastMessageAt!)).reversed.toList(),
      );
    });

    ref.onDispose(conversationSubscription.cancel);

    return await getConversations();
  }

  Future<List<E2eeConversationEntity>> getConversations() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final database = ref.read(conversationsDBServiceProvider);

      final eventSigner = await ref.read(currentUserIonConnectEventSignerProvider.future);

      if (eventSigner == null) {
        throw EventSignerNotFoundException();
      }

      final conversationsMessages = await database.getAllConversations();

      final conversations = await Future.wait(
        conversationsMessages
            .map((message) => _getConversationData(message, eventSigner.publicKey)),
      );

      return (conversations..sortBy<DateTime>((e) => e.lastMessageAt!)).reversed.toList();
    });

    return state.requireValue;
  }

  // TODO: Refactor and render conversation images in [recent_chat_tile]
  Future<E2eeConversationEntity> _getConversationData(
    PrivateDirectMessageEntity message,
    String devicePublicKey,
  ) async {
    final database = ref.read(conversationsDBServiceProvider);

    final conversationId = await database.lookupConversationByEventMessageId(message.id);

    var name = 'Unknown';
    String? nickname;
    var imageUrl = message.data.relatedGroupImagePath;

    final type = (message.data.relatedSubject != null) ? ChatType.group : ChatType.chat;
    final participants =
        message.data.relatedPubkeys?.map((toElement) => toElement.value).toList() ?? [];

    if (type == ChatType.chat) {
      final userMetadata = await ref.read(
        userMetadataProvider(
          message.data.relatedPubkeys!.where((key) => key.value != devicePublicKey).first.value,
        ).future,
      );

      if (userMetadata != null) {
        nickname = userMetadata.data.name;
        name = userMetadata.data.displayName;
        imageUrl = userMetadata.data.picture ?? '';
      }
    } else {
      name = message.data.relatedSubject?.value ?? '';

      // If the image is not available, download it from the server and update conversation messages
      if (imageUrl == null) {
        final conversationMessages = await database.getConversationMessages(
          E2eeConversationEntity(name: name, type: type, participants: participants),
        );

        final latestMessageWithIMetaTag =
            conversationMessages.firstWhere((m) => m.data.primaryMedia != null);

        final conversationMessageManagementService =
            await ref.read(conversationMessageManagementServiceProvider.future);

        final imageUrls = await conversationMessageManagementService
            .downloadDecryptDecompressMedia([latestMessageWithIMetaTag.data.primaryMedia!]);

        imageUrl = imageUrls.first.path;

        if (conversationId != null) {
          await database.updateGroupConversationImage(
            conversationId: conversationId,
            groupImagePath: imageUrl,
          );
        }
      }
    }

    final lastMessageAt = message.createdAt;

    final lastMessageContent = message.data.content.map((m) => m.text).join();

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
      lastMessageAt: lastMessageAt,
      lastMessageContent: lastMessageContent,
      unreadMessagesCount: unreadMessagesCount,
      participants: participants..sortBy<String>((e) => e),
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
