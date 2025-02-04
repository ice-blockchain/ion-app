// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/conversation_list_item.c.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_seperator/recent_chat_seperator.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/archive_chat_tile.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
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
              if (conversation.isArchived) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  if (index == 0 && !showArchive) const RecentChatSeparator(isAtTop: true),
                  if (conversation.type == ConversationType.community)
                    Column(
                      key: ValueKey(conversation.uuid),
                      children: [
                        CommunityRecentChatTile(conversation: conversation),
                        const RecentChatSeparator(),
                      ],
                    )
                  else if (conversation.type == ConversationType.e2ee)
                    Column(
                      key: ValueKey(conversation.uuid),
                      children: [
                        E2eeRecentChatTile(conversation: conversation),
                        const RecentChatSeparator(),
                      ],
                    ),
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

    return RecentChatTile(
      uuid: conversation.uuid,
      name: community.data.name,
      avatarUrl: community.data.avatar?.url,
      defaultAvatar: Assets.svg.iconContactList,
      lastMessageAt: conversation.latestMessage?.createdAt ?? conversation.joinedAt,
      lastMessageContent: conversation.latestMessage?.content ?? 'Community is created',
      unreadMessagesCount: unreadMessagesCount,
    );
  }
}

class E2eeRecentChatTile extends ConsumerWidget {
  const E2eeRecentChatTile({required this.conversation, super.key});

  final ConversationListItem conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = PrivateDirectMessageData.fromEventMessage(conversation.latestMessage!);
    // bool isOneOnOne = entity.relatedSubject == null;

    final receiver = entity.relatedPubkeys!.last;

    final userMetadata = ref.watch(userMetadataProvider(receiver.value)).valueOrNull;

    return RecentChatTile(
      uuid: conversation.uuid,
      name: userMetadata?.data.name ?? '',
      avatarUrl: userMetadata?.data.picture,
      defaultAvatar: Assets.svg.iconContactList,
      lastMessageAt: conversation.latestMessage?.createdAt ?? conversation.joinedAt,
      lastMessageContent: conversation.latestMessage?.content ?? 'E2EE',
      unreadMessagesCount: 0,
    );
  }
}
