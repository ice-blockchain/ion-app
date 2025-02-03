// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_edit_mode_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_conversations_ids_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ConversationUnarchiveButton extends ConsumerWidget {
  const ConversationUnarchiveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedConversations = ref.watch(selectedConversationsIdsProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (selectedConversations.isNotEmpty) {
          // await ref
          //     .read(e2eeConversationManagementProvider.notifier)
          //     .toggleArchivedConversations(selectedConversations);
          ref.read(conversationsEditModeProvider.notifier).editMode = false;
          ref.read(selectedConversationsIdsProvider.notifier).clear();
          if (context.mounted && context.canPop()) {
            context.pop();
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.svg.iconChatArchive.icon(
            color: selectedConversations.isNotEmpty
                ? context.theme.appColors.primaryAccent
                : context.theme.appColors.tertararyText,
            size: 20.0.s,
          ),
          SizedBox(width: 4.0.s),
          Flexible(
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              context.i18n.common_unarchive,
              style: context.theme.appTextThemes.body2.copyWith(
                color: selectedConversations.isNotEmpty
                    ? context.theme.appColors.primaryAccent
                    : context.theme.appColors.tertararyText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
