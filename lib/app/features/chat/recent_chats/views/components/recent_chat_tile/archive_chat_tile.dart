// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/hooks/use_combined_conversation_names.dart';
import 'package:ion/app/features/chat/model/message_type.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat/providers/unread_message_count_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/archive_state_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_edit_mode_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/selected_conversations_ids_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ArchiveChatTile extends HookConsumerWidget {
  const ArchiveChatTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(conversationsEditModeProvider);
    final selectedConversations = ref.watch(selectedConversationsProvider);
    final conversations = ref.watch(archivedConversationsProvider).valueOrNull ?? [];

    final unreadMessagesCount =
        ref.watch(getAllUnreadMessagesCountInArchiveProvider).valueOrNull ?? 0;

    final isSelected = useMemoized(
      () => selectedConversations.toSet().containsAll(conversations),
      [selectedConversations, conversations],
    );

    final combinedConversationNames = useCombinedConversationNames(conversations, ref);

    final latestMessageAt = useMemoized(
      () => conversations.isEmpty
          ? null
          : conversations
              .map((c) => c.latestMessage?.createdAt ?? c.joinedAt)
              .reduce((a, b) => a.isAfter(b) ? a : b),
      [conversations],
    );

    if (conversations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0.s),
      child: GestureDetector(
        onTap: () async {
          if (isEditMode) {
            ref.read(selectedConversationsProvider.notifier).toggleAll(conversations);
          } else {
            ref.read(archiveStateProvider.notifier).toggle();
            await ArchivedChatsMainRoute().push<void>(context);
            ref.read(archiveStateProvider.notifier).toggle();
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
                child: isSelected
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
                            if (latestMessageAt != null)
                              ChatTimestamp(
                                latestMessageAt,
                              ),
                          ],
                        ),
                        SizedBox(height: 2.0.s),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ChatPreview(
                                content: combinedConversationNames,
                                maxLines: 1,
                                messageType: MessageType.text,
                              ),
                            ),
                            UnreadCountBadge(unreadCount: unreadMessagesCount),
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
      ),
    );
  }
}
