// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_page/channel_messaging_page.dart';
import 'package:ion/app/features/chat/e2ee/data/models/database/chat_database.c.dart';
import 'package:ion/app/features/chat/e2ee/views/pages/group_messages_page.dart';
import 'package:ion/app/features/chat/e2ee/views/pages/one_to_one_messages_page.dart';
import 'package:ion/app/features/chat/providers/conversation_type_provider.c.dart';

class ConversationPage extends HookConsumerWidget {
  const ConversationPage({
    super.key,
    this.conversationId,
    this.receiverPubKey,
  });

  final String? conversationId;
  final String? receiverPubKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationType = ref.watch(conversationTypeProvider(conversationId, receiverPubKey));

    ref.displayErrors(conversationTypeProvider(conversationId, receiverPubKey));

    return conversationType.maybeWhen(
      data: (conversationType) {
        switch (conversationType) {
          case ConversationType.group:
            return GroupMessagesPage(conversationId: conversationId!);
          case ConversationType.community:
            return ChannelMessagingPage(communityId: conversationId!);
          case ConversationType.oneToOne:
            return OneToOneMessagesPage(
              receiverMasterPubkey: receiverPubKey!,
            );
        }
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
