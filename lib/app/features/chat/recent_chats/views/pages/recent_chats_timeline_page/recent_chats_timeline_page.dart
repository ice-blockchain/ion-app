// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/chat/model/conversation_list_item.c.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers-v2/unread_message_count_provider.c.dart';
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
                    CommunityRecentChatTile(
                      conversation: conversation,
                      key: ValueKey(conversation.uuid),
                    )
                  else if (conversation.type == ConversationType.oneToOne)
                    E2eeRecentChatTile(
                      conversation: conversation,
                      key: ValueKey(conversation.uuid),
                    )
                  else if (conversation.type == ConversationType.encryptedGroup)
                    E2eeRecentChatTile(
                      conversation: conversation,
                      key: ValueKey(conversation.uuid),
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

    final unreadMessagesCount = ref.watch(unreadMessageCountProviderProvider(conversation.uuid));
    if (community == null) {
      return const SizedBox.shrink();
    }

    return RecentChatTile(
      conversationUUID: conversation.uuid,
      name: community.data.name,
      avatarUrl: community.data.avatar?.url,
      defaultAvatar: Assets.svg.iconContactList,
      lastMessageAt: conversation.latestMessage?.createdAt ?? conversation.joinedAt,
      lastMessageContent: conversation.latestMessage?.content ?? 'Community is created',
      unreadMessagesCount: unreadMessagesCount.valueOrNull ?? 0,
      onTap: () {
        ChannelRoute(uuid: conversation.uuid).push<void>(context);
      },
    );
  }
}

class E2eeRecentChatTile extends ConsumerWidget {
  const E2eeRecentChatTile({required this.conversation, super.key});

  final ConversationListItem conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (conversation.latestMessage == null) {
      return const SizedBox.shrink();
    }

    final entity = PrivateDirectMessageData.fromEventMessage(conversation.latestMessage!);
    // bool isOneOnOne = entity.relatedSubject == null;

    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;

    final receiverPukeyKey =
        entity.relatedPubkeys?.firstWhere((p) => p.value != currentUserPubkey).value;

    if (receiverPukeyKey == null) {
      return const SizedBox.shrink();
    }

    final userMetadata = ref.watch(userMetadataProvider(receiverPukeyKey)).valueOrNull;

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    final unreadMessagesCount = ref.watch(unreadMessageCountProviderProvider(conversation.uuid));

    return RecentChatTile(
      conversationUUID: conversation.uuid,
      name: userMetadata.data.name,
      avatarUrl: userMetadata.data.picture,
      defaultAvatar: Assets.svg.iconContactList,
      lastMessageAt: conversation.latestMessage?.createdAt ?? conversation.joinedAt,
      lastMessageContent: conversation.latestMessage?.content ?? '',
      unreadMessagesCount: unreadMessagesCount.valueOrNull ?? 0,
      onTap: () {
        MessagesRoute(
          uuid: conversation.uuid,
          receiverPubKey: receiverPukeyKey,
        ).push<void>(context);
      },
    );
  }
}

class EncryptedGroupRecentChatTile extends ConsumerWidget {
  const EncryptedGroupRecentChatTile({required this.conversation, super.key});

  final ConversationListItem conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text('Encrypted Group');
  }
}
