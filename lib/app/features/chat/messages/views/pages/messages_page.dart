// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/providers/chat_messages_provider.c.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/model/chat_type.dart';
import 'package:ion/app/features/chat/model/conversation_data.c.dart';
import 'package:ion/app/features/chat/providers/e2ee_group_conversation_management_provider.c.dart';
import 'package:ion/app/features/chat/views/components/messages_list.dart';
import 'package:ion/app/features/core/views/pages/error_modal.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';
import 'package:ion/generated/assets.gen.dart';

const String hasPrivacyModalShownKey = 'hasPrivacyModalShownKey';

class MessagesPage extends HookConsumerWidget {
  const MessagesPage(this.conversationData, {super.key});

  final ConversationData conversationData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = useMemoized(() => Random().nextBool(), []);
    final messages = ref.watch(chatMessagesProvider);

    // TODO: Should be called if there is no conversation messages yet in DB
    // ignore: unused_element
    Future<void> initConversation() async {
      final ee2eGroupConversationService =
          ref.read(e2EEGroupConversationManagementProvider.notifier);

      if (conversationData.type == ChatType.chat) {
        await ee2eGroupConversationService.createOneOnOneConversation(conversationData.members);
      } else if (conversationData.type == ChatType.group && conversationData.mediaImage != null) {
        await ee2eGroupConversationService.createGroup(
          subject: conversationData.name,
          groupImage: conversationData.mediaImage!,
          participantsPubkeys: conversationData.members,
        );
      }
    }

    ref.listen(
      e2EEGroupConversationManagementProvider,
      (previous, next) async {
        if (next is AsyncError) {
          await showSimpleBottomSheet<void>(
            context: context,
            child: ErrorModal(error: next.error),
          );
        }
      },
    );

    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        backgroundColor: context.theme.appColors.secondaryBackground,
        body: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
          ),
          bottom: false,
          child: Column(
            children: [
              MessagingHeader(
                imageUrl: conversationData.imageUrl,
                name: conversationData.name,
                subtitle: Text(
                  conversationData.type == ChatType.chat
                      ? conversationData.nickname ?? ''
                      : conversationData.members.length.toString(),
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                ),
              ),
              if (isEmpty)
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
              const MessagingBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
