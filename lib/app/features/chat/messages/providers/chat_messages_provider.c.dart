// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/chat/database/conversation_db_service.c.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/message_author.c.dart';
import 'package:ion/app/features/chat/model/message_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/conversation_data.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_event_signer_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_messages_provider.c.g.dart';

@riverpod
class ChatMessages extends _$ChatMessages {
  @override
  Future<List<MessageListItem>> build(ConversationEntity conversation) async {
    final messagesSubscription =
        ref.watch(conversationsDBServiceProvider).watchConversationMessages(conversation.id).listen((messages) async {
      final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

      if (eventSigner == null) {
        throw EventSignerNotFoundException();
      }
      final conversationMessageItems =
          messages.map((message) => _mapMessage(message, eventSigner.publicKey)).nonNulls.toList();

      state = AsyncValue.data(conversationMessageItems);
    });

    ref.onDispose(messagesSubscription.cancel);

    state = const AsyncValue.loading();

    final eventSigner = await ref.watch(currentUserIonConnectEventSignerProvider.future);

    if (eventSigner == null) {
      throw EventSignerNotFoundException();
    }

    final messages = await ref.watch(conversationsDBServiceProvider).getConversationMessages(conversation.id);

    final conversationMessageItems =
        messages.map((message) => _mapMessage(message, eventSigner.publicKey)).nonNulls.toList();

    return conversationMessageItems;
  }

  MessageListItem? _mapMessage(
    PrivateDirectMessageEntity message,
    String devicePubkey,
  ) {
    if (message.data.content.map((e) => e.text).join().isEmpty) {
      return null;
    }
    return MessageListItem.text(
      time: message.createdAt,
      text: message.data.content.map((e) => e.text).join(),
      author: MessageAuthor(
        name: conversation.name,
        isCurrentUser: message.pubkey == devicePubkey,
      ),
    );
  }
}
