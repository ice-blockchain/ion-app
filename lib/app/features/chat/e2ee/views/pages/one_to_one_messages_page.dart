// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/views/components/e2ee_conversation_empty_view.dart';
import 'package:ion/app/features/chat/e2ee/views/components/one_to_one_messages_list.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/conversation_messages_provider.c.dart';
import 'package:ion/app/features/chat/providers/exist_chat_conversation_id_provider.c.dart';
import 'package:ion/app/features/chat/providers/muted_conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_edit_message_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_reply_message_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/edit_message_info/edit_message_info.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/messaging_bottom_bar.dart';
import 'package:ion/app/features/chat/views/components/message_items/replied_message_info/replied_message_info.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/username.dart';

class OneToOneMessagesPage extends HookConsumerWidget {
  const OneToOneMessagesPage({
    required this.receiverPubKey,
    super.key,
  });

  final String receiverPubKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(sendE2eeMessageServiceProvider);
    final conversationId = useState<String?>(null);

    useEffect(
      () {
        ref.read(existChatConversationIdProvider(receiverPubKey).future).then(
          (value) {
            conversationId.value = value ??
                ref.read(sendE2eeChatMessageServiceProvider).generateConversationId(
                      receiverPubkey: receiverPubKey,
                    );
          },
        );
        return null;
      },
    );

    final onSubmitted = useCallback(
      ({String? content, List<MediaFile>? mediaFiles}) async {
        final currentPubkey = ref.read(currentPubkeySelectorProvider);
        if (currentPubkey == null) {
          throw UserMasterPubkeyNotFoundException();
        }

        final repliedMessage = ref.read(selectedReplyMessageProvider);
        final editedMessage = ref.read(selectedEditMessageProvider);

        ref.read(selectedEditMessageProvider.notifier).clear();
        ref.read(selectedReplyMessageProvider.notifier).clear();

        await ref.read(sendE2eeChatMessageServiceProvider).sendMessage(
          content: content ?? '',
          mediaFiles: mediaFiles ?? [],
          conversationId: conversationId.value!,
          editedMessage: editedMessage?.eventMessage,
          repliedMessage: repliedMessage?.eventMessage,
          participantsMasterPubkeys: [receiverPubKey, currentPubkey],
        );
      },
      [receiverPubKey],
    );

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              receiverMasterPubKey: receiverPubKey,
              conversationId: conversationId.value ?? '',
            ),
            _MessagesList(conversationId: conversationId.value),
            const EditMessageInfo(),
            const RepliedMessageInfo(),
            MessagingBottomBar(onSubmitted: onSubmitted, conversationId: conversationId.value),
          ],
        ),
      ),
    );
  }
}

class _Header extends HookConsumerWidget {
  const _Header({required this.receiverMasterPubKey, required this.conversationId});

  final String receiverMasterPubKey;
  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiver = ref.watch(userMetadataProvider(receiverMasterPubKey)).valueOrNull;

    if (receiver == null) {
      return const SizedBox.shrink();
    }

    return MessagingHeader(
      imageUrl: receiver.data.picture,
      name: receiver.data.displayName,
      onTap: () => ProfileRoute(pubkey: receiverMasterPubKey).push<void>(context),
      subtitle: Text(
        prefixUsername(username: receiver.data.name, context: context),
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.quaternaryText,
        ),
      ),
      conversationId: conversationId,
      onToggleMute: () {
        ref.read(mutedConversationsProvider.notifier).toggleMutedMasterPubkey(receiverMasterPubKey);
      },
    );
  }
}

class _MessagesList extends ConsumerWidget {
  const _MessagesList({required this.conversationId});

  final String? conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (conversationId == null) {
      return const Expanded(child: E2eeConversationEmptyView());
    }

    final messages =
        ref.watch(conversationMessagesProvider(conversationId!, ConversationType.oneToOne));

    return Expanded(
      child: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: messages.maybeWhen(
          data: (messages) {
            if (messages.isEmpty) {
              return const E2eeConversationEmptyView();
            }
            return OneToOneMessageList(messages);
          },
          orElse: E2eeConversationEmptyView.new,
        ),
      ),
    );
  }
}
