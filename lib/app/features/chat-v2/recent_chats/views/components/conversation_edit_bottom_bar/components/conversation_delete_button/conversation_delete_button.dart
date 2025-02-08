// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat-v2/recent_chats/providers/conversations_edit_mode_provider.c.dart';
import 'package:ion/app/features/chat-v2/recent_chats/providers/selected_conversations_ids_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ConversationDeleteButton extends ConsumerWidget {
  const ConversationDeleteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedConversations = ref.watch(selectedConversationsProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (selectedConversations.isNotEmpty) {
          ref.invalidate(selectedConversationsProvider);
          ref.read(conversationsEditModeProvider.notifier).editMode = false;
          //TODO: when flow is ready to support for e2ee and non e2ee conversations
          // DeleteConversationRoute(conversationIds: selectedConversationsIds)
          //     .push<void>(context)
          //     .then((_) {
          // });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Assets.svg.iconBlockDelete.icon(
            color: selectedConversations.isNotEmpty
                ? context.theme.appColors.attentionRed
                : context.theme.appColors.tertararyText,
            size: 20.0.s,
          ),
          SizedBox(width: 4.0.s),
          Flexible(
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              context.i18n.button_delete,
              style: context.theme.appTextThemes.body2.copyWith(
                color: selectedConversations.isNotEmpty
                    ? context.theme.appColors.attentionRed
                    : context.theme.appColors.tertararyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
