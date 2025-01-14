// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversation_message_management_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/ee2e_conversation_data.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/services/database/conversation_db_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.c.g.dart';

@Riverpod(keepAlive: true)
class Conversations extends _$Conversations {
  @override
  FutureOr<List<Ee2eConversationEntity>> build() async {
    final conversationSubscription = ref
        .read(conversationsDBServiceProvider)
        .watchConversations()
        .listen((conversationsEventMessages) async {
      final lastPrivateDirectMesssages =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

      final conversations = await Future.wait(lastPrivateDirectMesssages.map(getConversationData));

      state = AsyncValue.data(conversations);
    });

    ref.onDispose(conversationSubscription.cancel);

    state = const AsyncValue.loading();
    try {
      final database = ref.read(conversationsDBServiceProvider);
      final conversationsEventMessages = await database.getAllConversations();

      final lastPrivateDirectMesssages =
          conversationsEventMessages.map(PrivateDirectMessageEntity.fromEventMessage).toList();

      final conversations = await Future.wait(lastPrivateDirectMesssages.map(getConversationData));

      state = AsyncValue.data(conversations);

      return conversations;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<Ee2eConversationEntity> getConversationData(PrivateDirectMessageEntity message) async {
    var name = 'Unknown';
    String? nickname;
    String? imageUrl;
    String? imagePath;

    final type = (message.data.relatedSubject != null) ? ChatType.group : ChatType.chat;

    if (type == ChatType.chat) {
      final userMetadata =
          ref.watch(userMetadataProvider(message.data.relatedPubkeys!.first.value)).valueOrNull;

      if (userMetadata != null) {
        nickname = userMetadata.data.name;
        name = userMetadata.data.displayName;
        imageUrl = userMetadata.data.picture ?? '';
      }
    } else {
      name = message.data.relatedSubject?.value ?? '';

      try {
        final conversationMessageManagementService =
            await ref.watch(conversationMessageManagementServiceProvider);
        final imageUrls =
            await conversationMessageManagementService.downloadDecryptDecompressMedia(message);
        imagePath = imageUrls.first.path;
      } catch (e) {
        // Handle
      }
    }

    final lastMessageAt = message.createdAt;
    final participants =
        message.data.relatedPubkeys?.map((toElement) => toElement.value).toList() ?? [];
    final lastMessageContent = message.data.content.toString();

    return Ee2eConversationEntity(
      name: name,
      type: type,
      nickname: nickname,
      imageUrl: imageUrl,
      imagePath: imagePath,
      participants: participants,
      lastMessageAt: lastMessageAt,
      lastMessageContent: lastMessageContent,
    );
  }
}
