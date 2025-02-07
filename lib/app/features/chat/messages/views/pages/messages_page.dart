// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/default_avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/providers/chat_messages_provider.c.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/providers/e2ee_conversation_management_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/conversation_data.c.dart';
import 'package:ion/app/features/chat/views/components/messages_list.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagesPage extends HookConsumerWidget {
  const MessagesPage(this.conversation, {super.key});

  final ConversationEntity conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessagesProvider(conversation)).value ?? [];

    ref
      ..displayErrors(e2eeConversationManagementProvider)
      ..displayErrors(chatMessagesProvider(conversation));

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
          ),
          bottom: false,
          child: Column(
            children: [
              MessagingHeader(
                name: conversation.name,
                imageUrl: conversation.type == ChatType.oneOnOne ? conversation.imageUrl : null,
                imageWidget: conversation.type == ChatType.group
                    ? Image.asset(
                        conversation.imageUrl!,
                        errorBuilder: (_, __, ___) => DefaultAvatar(size: 36.0.s),
                      )
                    : null,
                subtitle: conversation.type == ChatType.oneOnOne
                    ? Text(
                        conversation.nickname,
                        style: context.theme.appTextThemes.caption.copyWith(
                          color: context.theme.appColors.quaternaryText,
                        ),
                      )
                    : Row(
                        children: [
                          Assets.svg.iconChannelMembers.icon(size: 10.0.s),
                          SizedBox(width: 4.0.s),
                          Text(
                            conversation.participantsMasterPubkeys.length.toString(),
                            style: context.theme.appTextThemes.caption.copyWith(
                              color: context.theme.appColors.quaternaryText,
                            ),
                          ),
                        ],
                      ),
              ),
              if (messages.isEmpty)
                MessagingEmptyView(
                  title: context.i18n.messaging_empty_description,
                  asset: Assets.svg.walletChatEmptystate,
                  trailing: GestureDetector(
                    onTap: () {
                      ChatLearnMoreModalRoute().push<void>(context);
                    },
                    child: Text(
                      context.i18n.button_learn_more,
                      style: context.theme.appTextThemes.caption.copyWith(
                        color: context.theme.appColors.primaryAccent,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ChatMessagesList(messages),
                ),
              MessagingBottomBar(conversation: conversation),
            ],
          ),
        ),
      ),
    );
  }
}
