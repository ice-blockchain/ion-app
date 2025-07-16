// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_page/channel_messaging_page.dart';
import 'package:ion/app/features/chat/e2ee/views/pages/group_messages_page.dart';
import 'package:ion/app/features/chat/e2ee/views/pages/one_to_one_messages_page.dart';
import 'package:ion/app/features/chat/model/database/chat_database.m.dart';
import 'package:ion/app/features/chat/providers/conversation_type_provider.r.dart';
import 'package:ion/app/features/chat/providers/message_status_provider.r.dart';
import 'package:ion/app/features/chat/recent_chats/providers/replied_message_list_item_provider.r.dart';

class ConversationPage extends HookConsumerWidget {
  const ConversationPage({
    super.key,
    this.conversationId,
    this.receiverMasterPubkey,
  });

  final String? conversationId;
  final String? receiverMasterPubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationType =
        ref.watch(conversationTypeProvider(conversationId, receiverMasterPubkey));

    ref.displayErrors(conversationTypeProvider(conversationId, receiverMasterPubkey));

    return conversationType.maybeWhen(
      data: (conversationType) {
        switch (conversationType) {
          case ConversationType.group:
            return GroupMessagesPage(conversationId: conversationId!);
          case ConversationType.community:
            return ChannelMessagingPage(communityId: conversationId!);
          case ConversationType.oneToOne:
            return ProviderScope(
              overrides: const [messageStatusProvider, repliedMessageListItemProvider],
              child: OneToOneMessagesPage(
                receiverMasterPubkey: receiverMasterPubkey!,
              ),
            );
        }
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
