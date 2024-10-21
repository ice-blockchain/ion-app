// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_edit_mode_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class ConversationDeleteButton extends ConsumerWidget {
  const ConversationDeleteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedConversationsIds = ref.watch(selectedConversationsIdsProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (selectedConversationsIds.isNotEmpty) {
          ref.read(conversationsEditModeProvider.notifier).editMode = false;
        } else {}
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Assets.svg.iconBlockDelete.icon(
            color: selectedConversationsIds.isNotEmpty
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
                color: selectedConversationsIds.isNotEmpty
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
