// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/database/conversation_db_service.c.dart';
import 'package:ion/app/features/chat/model/chat_participant_data.c.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/conversation_data.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_metadata_provider.c.g.dart';

@riverpod
class ConversationMetadata extends _$ConversationMetadata {
  @override
  Future<ConversationEntity> build(
    ConversationEntity conversation, {
    bool loadPubkeys = false,
  }) async {
    state = const AsyncValue.loading();

    var updatedConversation = conversation;

    final database = ref.read(conversationsDBServiceProvider);
    final unreadMessagesCount = await database.getUnreadMessagesCount(updatedConversation.id);

    if (loadPubkeys) {
      updatedConversation = await _getParticipantsWithPubkeys();
    }

    if (updatedConversation.type == ChatType.oneOnOne) {
      final participantsMasterPubkeys =
          updatedConversation.participants.map((p) => p.masterPubkey).toList();
      final currentMasterPubkey = await ref.watch(currentPubkeySelectorProvider.future);

      if (currentMasterPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final masterPubkey =
          participantsMasterPubkeys.where((key) => key != currentMasterPubkey).singleOrNull;

      if (masterPubkey == null) {
        throw UserMetadataNotFoundException(masterPubkey ?? '?');
      }

      final userMetadata = await ref.watch(userMetadataProvider(masterPubkey).future);

      if (userMetadata == null) {
        throw UserMetadataNotFoundException(masterPubkey);
      }

      final nickname = userMetadata.data.name;
      final name = userMetadata.data.displayName;
      final imageUrl = userMetadata.data.picture;

      return ConversationEntity(
        name: name,
        nickname: nickname,
        imageUrl: imageUrl,
        unreadMessagesCount: unreadMessagesCount,
        participants: List.from(updatedConversation.participants)
          ..sortBy<String>((e) => e.masterPubkey),
        //
        id: updatedConversation.id,
        type: updatedConversation.type,
        isArchived: updatedConversation.isArchived,
        lastMessageAt: updatedConversation.lastMessageAt,
        lastMessageContent: updatedConversation.lastMessageContent,
      );
    } else {
      var imageUrl = updatedConversation.imageUrl;
      // If the image is not available, download it from the server and update conversation messages
      if (updatedConversation.imageUrl == null) {
        final conversationMessages = await database.getConversationMessages(updatedConversation.id);
        final latestMessageWithIMetaTag =
            conversationMessages.firstWhereOrNull((m) => m.data.primaryMedia != null);

        final conversationMessageManagementService =
            await ref.read(conversationMessageManagementServiceProvider.future);

        if (latestMessageWithIMetaTag != null) {
          final imageUrls = await conversationMessageManagementService
              .downloadDecryptDecompressMedia([latestMessageWithIMetaTag.data.primaryMedia!]);

          imageUrl = imageUrls.single.path;

          await database.updateGroupConversationImage(
            groupImagePath: imageUrl,
            conversationId: updatedConversation.id,
          );
        }
      }

      return ConversationEntity(
        imageUrl: imageUrl,
        unreadMessagesCount: unreadMessagesCount,
        //
        id: updatedConversation.id,
        name: updatedConversation.name,
        type: updatedConversation.type,
        isArchived: updatedConversation.isArchived,
        participants: updatedConversation.participants,
        lastMessageAt: updatedConversation.lastMessageAt,
        lastMessageContent: updatedConversation.lastMessageContent,
      );
    }
  }

  Future<ConversationEntity> _getParticipantsWithPubkeys() async {
    final participantsMasterPubkeys = conversation.participants.map((p) => p.masterPubkey);

    final participantsWithPubkeys = await Future.wait(
      participantsMasterPubkeys.map((masterPubkey) async {
        final userMetadata = await ref.watch(userMetadataProvider(masterPubkey).future);

        if (userMetadata == null) {
          throw UserMetadataNotFoundException(masterPubkey);
        }

        return ChatParticipantData(
          pubkey: userMetadata.pubkey,
          masterPubkey: userMetadata.masterPubkey,
        );
      }),
    );

    return conversation.copyWith(participants: participantsWithPubkeys);
  }
}
