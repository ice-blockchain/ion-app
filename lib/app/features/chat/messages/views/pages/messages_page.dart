// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/providers/chat_messages_provider.c.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/providers/e2ee_conversation_management_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/entities/ee2e_conversation_data.c.dart';
import 'package:ion/app/features/chat/views/components/messages_list.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagesPage extends HookConsumerWidget {
  MessagesPage(E2eeConversationEntity conversation, {super.key})
      : _conversation = conversation.copyWith(
            participants: List<String>.from(conversation.participants)..sortBy<String>((e) => e));

  final E2eeConversationEntity _conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessagesProvider(_conversation)).value ?? [];

    ref
      ..displayErrors(e2eeConversationManagementProvider)
      ..displayErrors(chatMessagesProvider(_conversation));

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SafeArea(
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
        ),
        bottom: false,
        child: Column(
          children: [
            MessagingHeader(
              imageUrl: _conversation.imageUrl,
              imageWidget: _conversation.imageUrl != null &&
                      _conversation.imageUrl.isNotEmpty &&
                      _conversation.type == ChatType.group
                  ? Image.asset(_conversation.imageUrl!)
                  : null,
              name: _conversation.name,
              subtitle: _conversation.type == ChatType.chat
                  ? Text(
                      _conversation.nickname ?? '',
                      style: context.theme.appTextThemes.caption.copyWith(
                        color: context.theme.appColors.quaternaryText,
                      ),
                    )
                  : Row(
                      children: [
                        Assets.svg.iconChannelMembers.icon(size: 10.0.s),
                        SizedBox(width: 4.0.s),
                        Text(
                          _conversation.participants.length.toString(),
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
            MessagingBottomBar(e2eeConversation: _conversation),
          ],
        ),
      ),
    );
  }
}
