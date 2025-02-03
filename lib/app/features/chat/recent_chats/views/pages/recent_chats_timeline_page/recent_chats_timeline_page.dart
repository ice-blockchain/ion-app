// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/conversation_list_item.c.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_seperator/recent_chat_seperator.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/archive_chat_tile.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class RecentChatsTimelinePage extends ConsumerWidget {
  const RecentChatsTimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsProvider).valueOrNull;

    if (conversations == null) {
      return const SizedBox.shrink();
    }

    ref.displayErrors(conversationsProvider);

    final showArchive = conversations.any((c) => c.isArchived);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => ChatSimpleSearchRoute().push<void>(context),
              child: const IgnorePointer(
                child: SearchInput(),
              ),
            ),
          ),
          toolbarHeight: SearchInput.height,
        ),
        if (showArchive) const SliverToBoxAdapter(child: RecentChatSeparator(isAtTop: true)),
        if (showArchive) const SliverToBoxAdapter(child: ArchiveChatTile()),
        if (showArchive) const SliverToBoxAdapter(child: RecentChatSeparator()),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final conversation = conversations[index];
              // if (conversation.isArchived) {
              if (false) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  if (index == 0 && !showArchive) const RecentChatSeparator(isAtTop: true),
                  const RecentChatSeparator(),
                  if (conversation.type == ConversationType.community)
                    CommunityRecentChatTile(conversation: conversation),
                  // else
                  //   RecentChatTile(conversation.uuid, conversation.name, conversation.imageUrl,
                  //       conversation.lastMessageAt, conversation.lastMessageContent,
                  //       conversation.unreadMessagesCount),
                ],
              );
            },
            childCount: conversations.length,
          ),
        ),
      ],
    );
  }
}

class CommunityRecentChatTile extends ConsumerWidget {
  const CommunityRecentChatTile({required this.conversation, super.key});

  final ConversationListItem conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final community = ref.watch(communityMetadataProvider(conversation.uuid)).valueOrNull;

    if (community == null) {
      return const SizedBox.shrink();
    }

    const unreadMessagesCount = 10;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ChannelDetailRoute(uuid: conversation.uuid).push<void>(context),
      child: RecentChatTile(
        uuid: conversation.uuid,
        name: community.data.name,
        avatarUrl: community.data.avatar?.url,
        defaultAvatar: Assets.svg.iconContactList,
        lastMessageAt: conversation.latestMessage?.createdAt ?? community.createdAt,
        lastMessageContent: conversation.latestMessage?.content ?? 'Community is created',
        unreadMessagesCount: unreadMessagesCount,
      ),
    );
  }
}
