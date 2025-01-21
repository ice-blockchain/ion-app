// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_edit_mode_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_conversations_ids_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ArchiveChatTile extends ConsumerWidget {
  const ArchiveChatTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(conversationsEditModeProvider);
    final selectedConversationsIds = ref.watch(selectedConversationsIdsProvider);
    final conversations =
        ref.watch(conversationsProvider).valueOrNull?.where((c) => c.isArchived).toList() ?? [];

    return GestureDetector(
      onTap: () {
        if (isEditMode) {
          ref.read(selectedConversationsIdsProvider.notifier).toggle(conversations);
        } else {
          ArchivedChatsMainRoute().push<void>(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isEditMode ? 40.0.s : 0,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0.s),
              child: selectedConversationsIds.toSet().containsAll(conversations)
                  ? Assets.svg.iconBlockCheckboxOn.icon(size: 24.0.s)
                  : Assets.svg.iconBlockCheckboxOff.icon(size: 24.0.s),
            ),
          ),
          Flexible(
            child: Row(
              children: [
                Avatar(
                  imageWidget: Assets.svg.avatarArchive.icon(),
                  size: 40.0.s,
                ),
                SizedBox(width: 12.0.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            context.i18n.common_archive,
                            style: context.theme.appTextThemes.subtitle3.copyWith(
                              color: context.theme.appColors.primaryText,
                            ),
                          ),
                          ChatTimestamp(
                            conversations
                                .sortedBy<DateTime>((c) => c.lastMessageAt ?? DateTime.now())
                                .last
                                .lastMessageAt!,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.0.s),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ChatPreview(
                              content: conversations.map((c) => c.name).join(', '),
                              maxLines: 1,
                            ),
                          ),
                          UnreadCountBadge(
                            unreadCount: conversations
                                .map((c) => c.unreadMessagesCount!)
                                .reduce((a, b) => a + b),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
