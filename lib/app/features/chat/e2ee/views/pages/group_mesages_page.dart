// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/view/components/community_member_count_tile.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/e2ee/providers/send_e2ee_message_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/views/components/e2ee_conversation_empty_view.dart';
import 'package:ion/app/features/chat/e2ee/views/components/one_to_one_messages_list.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/conversation_messages_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/messaging_bottom_bar.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';

class GroupMessagesPage extends HookConsumerWidget {
  const GroupMessagesPage({
    required this.conversationId,
    super.key,
  });

  final String conversationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(sendE2eeMessageServiceProvider);

    final messages = ref
        .watch(
          conversationMessagesProvider(conversationId, ConversationType.group),
        )
        .valueOrNull;

    final lastMessage = messages?.entries.lastOrNull?.value.last;

    if (lastMessage == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            _Header(lastMessage: lastMessage),
            _MessagesList(conversationId: conversationId),
            MessagingBottomBar(
              onSubmitted: ({content, mediaFiles}) async {
                final currentPubkey = ref.read(currentPubkeySelectorProvider);
                if (currentPubkey == null) {
                  throw UserMasterPubkeyNotFoundException();
                }

                final privateMesssageEntity =
                    PrivateDirectMessageData.fromEventMessage(lastMessage);

                final conversationMessageManagementService =
                    await ref.read(sendE2eeMessageServiceProvider.future);

                final groupImageTag = lastMessage.tags.firstWhereOrNull((e) => e.first == 'imeta');

                await conversationMessageManagementService.sendMessage(
                  conversationId: conversationId,
                  content: content ?? '',
                  mediaFiles: mediaFiles ?? [],
                  groupImageTag: groupImageTag,
                  subject: privateMesssageEntity.relatedSubject?.value,
                  participantsMasterPubkeys:
                      privateMesssageEntity.relatedPubkeys?.map((e) => e.value).toList() ?? [],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends HookConsumerWidget {
  const _Header({required this.lastMessage});

  final EventMessage lastMessage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = PrivateDirectMessageData.fromEventMessage(lastMessage);
    final groupImageFile = useFuture(
      ref.watch(mediaEncryptionServiceProvider).retrieveEncryptedMedia(
            entity.primaryMedia!,
          ),
    ).data;

    return MessagingHeader(
      imageWidget: groupImageFile != null ? Image.file(groupImageFile) : null,
      name: entity.relatedSubject?.value ?? '',
      subtitle: MemberCountTile(count: entity.relatedPubkeys?.length ?? 0),
    );
  }
}

class _MessagesList extends ConsumerWidget {
  const _MessagesList({required this.conversationId});

  final String conversationId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages =
        ref.watch(conversationMessagesProvider(conversationId, ConversationType.group));
    return Expanded(
      child: messages.maybeWhen(
        data: (messages) {
          if (messages.isEmpty) {
            return const E2eeConversationEmptyView();
          }
          return OneToOneMessageList(messages);
        },
        orElse: () => const SizedBox.expand(),
      ),
    );
  }
}
