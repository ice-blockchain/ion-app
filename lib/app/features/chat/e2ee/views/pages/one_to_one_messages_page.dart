// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/container_skeleton.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/components/messaging_header/one_to_one_messaging_header.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_chat_message/send_e2ee_chat_message_service.c.dart';
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
import 'package:ion/app/features/user_metadata/providers/user_metadata_from_db_provider.c.dart';
import 'package:ion/app/features/user_metadata/providers/user_metadata_sync_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class OneToOneMessagesPage extends HookConsumerWidget {
  const OneToOneMessagesPage({
    required this.receiverMasterPubkey,
    super.key,
  });

  final String receiverMasterPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationId = useState<String?>(null);

    useOnInit(() {
      unawaited(
        ref
            .read(userMetadataSyncProvider.notifier)
            .syncUserMetadata(masterPubkeys: {receiverMasterPubkey}),
      );
    });

    useEffect(
      () {
        ref.read(existChatConversationIdProvider(receiverMasterPubkey).future).then(
          (value) {
            conversationId.value = value ??
                ref.read(sendE2eeChatMessageServiceProvider).generateConversationId(
                      receiverPubkey: receiverMasterPubkey,
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
          participantsMasterPubkeys: [receiverMasterPubkey, currentPubkey],
        );
      },
      [receiverMasterPubkey],
    );

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              receiverMasterPubkey: receiverMasterPubkey,
              conversationId: conversationId.value ?? '',
            ),
            _MessagesList(conversationId: conversationId.value),
            const EditMessageInfo(),
            const RepliedMessageInfo(),
            MessagingBottomBar(
              onSubmitted: onSubmitted,
              conversationId: conversationId.value,
              receiverMasterPubkey: receiverMasterPubkey,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends HookConsumerWidget {
  const _Header({
    required this.conversationId,
    required this.receiverMasterPubkey,
  });

  final String receiverMasterPubkey;
  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiverPicture = ref.watch(
      userMetadataFromDbNotifierProvider(receiverMasterPubkey).select((data) => data?.data.picture),
    );

    final receiverName = ref.watch(
      userMetadataFromDbNotifierProvider(receiverMasterPubkey).select((data) => data?.data.name),
    );

    final receiverDisplayName = ref.watch(
      userMetadataFromDbNotifierProvider(receiverMasterPubkey)
          .select((data) => data?.data.displayName),
    );

    if (receiverName == null || receiverDisplayName == null) {
      return const _HeaderSkeleton();
    }

    return OneToOneMessagingHeader(
      conversationId: conversationId,
      imageUrl: receiverPicture,
      name: receiverDisplayName,
      receiverMasterPubkey: receiverMasterPubkey,
      onTap: () => ProfileRoute(pubkey: receiverMasterPubkey).push<void>(context),
      subtitle: Text(
        prefixUsername(
          context: context,
          username: receiverName,
        ),
        style: context.theme.appTextThemes.caption.copyWith(
          color: context.theme.appColors.quaternaryText,
        ),
      ),
      onToggleMute: () {
        ref.read(mutedConversationsProvider.notifier).toggleMutedMasterPubkey(receiverMasterPubkey);
      },
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0.s, 8.0.s, 16.0.s, 12.0.s),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Assets.svg.iconChatBack.icon(
              size: 24.0.s,
              flipForRtl: true,
            ),
          ),
          SizedBox(width: 12.0.s),
          ContainerSkeleton(
            height: 36.0.s,
            width: 36.0.s,
            skeletonBaseColor: context.theme.appColors.onTerararyFill,
          ),
          SizedBox(width: 10.0.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContainerSkeleton(
                  height: context.theme.appTextThemes.subtitle3.fontSize!.s,
                  width: 120.0.s,
                  skeletonBaseColor: context.theme.appColors.onTerararyFill,
                ),
                SizedBox(height: 4.0.s),
                ContainerSkeleton(
                  height: context.theme.appTextThemes.subtitle3.fontSize!.s,
                  width: 150.0.s,
                  skeletonBaseColor: context.theme.appColors.onTerararyFill,
                ),
              ],
            ),
          ),
        ],
      ),
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
