// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/recent_chats/providers/archive_state_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/conversation_edit_bottom_bar/components/conversation_archive_button/conversation_archive_button.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/conversation_edit_bottom_bar/components/conversation_archive_button/conversation_unarchive_button.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/conversation_edit_bottom_bar/components/conversation_delete_button/conversation_delete_button.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/conversation_edit_bottom_bar/components/conversation_read_all_button/conversation_read_all_button.dart';

class ConversationEditBottomBar extends ConsumerWidget {
  const ConversationEditBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archiveOpened = ref.read(archiveStateProvider).falseOrValue;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        alignment: Alignment.topCenter,
        color: context.theme.appColors.secondaryBackground,
        padding: EdgeInsets.only(top: 16.0.s, left: 16.0.s, right: 16.0.s),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: ConversationReadAllButton()),
            if (archiveOpened)
              const Expanded(child: ConversationUnarchiveButton())
            else
              const Expanded(child: ConversationArchiveButton()),
            const Expanded(child: ConversationDeleteButton()),
          ],
        ),
      ),
    );
  }
}
