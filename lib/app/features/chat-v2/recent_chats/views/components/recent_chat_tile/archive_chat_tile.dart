// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat-v2/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat-v2/database/chat_database.c.dart';
import 'package:ion/app/features/chat-v2/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat-v2/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat-v2/recent_chats/providers/conversations_edit_mode_provider.c.dart';
import 'package:ion/app/features/chat-v2/recent_chats/providers/selected_conversations_ids_provider.c.dart';
import 'package:ion/app/features/chat-v2/recent_chats/views/components/recent_chat_seperator/recent_chat_seperator.dart';
import 'package:ion/app/features/chat-v2/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ArchiveChatTile extends HookConsumerWidget {
  const ArchiveChatTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(conversationsEditModeProvider);
    final selectedConversations = ref.watch(selectedConversationsProvider);
    final conversations = ref.watch(archivedConversationsProvider).valueOrNull ?? [];

    final isSelected = useMemoized(
      () => selectedConversations.toSet().containsAll(conversations),
      [selectedConversations, conversations],
    );

    final combinedConversationNames = useFuture(
      useMemoized(
        () async {
          final names = <String>[];
          for (final conversation in conversations) {
            if (conversation.type == ConversationType.oneToOne) {
              final latestMessageEntity =
                  PrivateDirectMessageData.fromEventMessage(conversation.latestMessage!);
              final receiver = latestMessageEntity.relatedPubkeys!.last.value;
              final userMetadata = await ref.read(userMetadataProvider(receiver).future);
              if (userMetadata != null) {
                names.add(userMetadata.data.displayName);
              }
            } else if (conversation.type == ConversationType.community) {
              final community = await ref.read(communityMetadataProvider(conversation.uuid).future);
              names.add(community.data.name);
            } else {
              final latestMessageEntity =
                  PrivateDirectMessageData.fromEventMessage(conversation.latestMessage!);
              names.add(latestMessageEntity.relatedSubject?.value ?? '');
            }
          }

          return names.join(', ');
        },
        [conversations],
      ),
    );

    final latestMessageAt = useMemoized(
      () => conversations.isEmpty
          ? null
          : conversations
              .map((c) => c.latestMessage?.createdAt ?? c.joinedAt)
              .reduce((a, b) => a.isAfter(b) ? a : b),
      [conversations],
    );

    if (conversations.isEmpty ||
        combinedConversationNames.data == null ||
        combinedConversationNames.data!.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        if (isEditMode) {
          ref.read(selectedConversationsProvider.notifier).toggleAll(conversations);
        } else {
          ArchivedChatsMainRoute().push<void>(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
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
                                  content: combinedConversationNames.data ?? '',
                                  maxLines: 1,
                                ),
                              ),
                              const UnreadCountBadge(
                                unreadCount: 30,
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
          const RecentChatSeparator(),
        ],
      ),
    );
  }
}
