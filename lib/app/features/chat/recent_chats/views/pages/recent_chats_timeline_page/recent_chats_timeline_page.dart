// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.c.dart'
    hide archivedConversationsProvider;
import 'package:ion/app/features/chat/providers/unread_message_count_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/archived_conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_seperator/recent_chat_seperator.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/archive_chat_tile.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_encryption_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class RecentChatsTimelinePage extends HookConsumerWidget {
  const RecentChatsTimelinePage({required this.conversations, super.key});

  final List<ConversationListItem> conversations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnInit(() {
      ref.read(archivedConversationsProvider);
    });

    return PullToRefreshBuilder(
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
        const SliverToBoxAdapter(child: RecentChatSeparator(isAtTop: true)),
        const SliverToBoxAdapter(child: ArchiveChatTile()),
        ConversationList(conversations: conversations.where((c) => !c.isArchived).toList()),
      ],
      onRefresh: () async => ref.invalidate(conversationsProvider),
      builder: (context, slivers) => CustomScrollView(
        slivers: slivers,
      ),
    );
  }
}

class ConversationList extends ConsumerWidget {
  const ConversationList({required this.conversations, super.key});

  final List<ConversationListItem> conversations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList.builder(
      itemBuilder: (BuildContext context, int index) {
        final conversation = conversations[index];
        return Column(
          children: [
            if (conversation.type == ConversationType.community)
              CommunityRecentChatTile(
                conversation: conversation,
                key: ValueKey(conversation.conversationId),
              )
            else if (conversation.type == ConversationType.oneToOne)
              E2eeRecentChatTile(
                conversation: conversation,
                key: ValueKey(conversation.conversationId),
              )
            else if (conversation.type == ConversationType.group)
              EncryptedGroupRecentChatTile(
                conversation: conversation,
                key: ValueKey(conversation.conversationId),
              ),
          ],
        );
      },
      itemCount: conversations.length,
    );
  }
}

class CommunityRecentChatTile extends ConsumerWidget {
  const CommunityRecentChatTile({required this.conversation, super.key});

  final ConversationListItem conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final community = ref.watch(communityMetadataProvider(conversation.conversationId)).valueOrNull;

    final unreadMessagesCount =
        ref.watch(getUnreadMessagesCountProvider(conversation.conversationId));
    if (community == null) {
      return const SizedBox.shrink();
    }

    return RecentChatTile(
      conversation: conversation,
      name: community.data.name,
      avatarUrl: community.data.avatar?.url,
      defaultAvatar: Container(
        decoration: BoxDecoration(
          color: context.theme.appColors.onTerararyFill,
          borderRadius: BorderRadius.circular(12.0.s),
        ),
        alignment: Alignment.center,
        width: 40.0.s,
        height: 40.0.s,
        child: Assets.svg.iconChannelEmptychannel.icon(
          size: 26.0.s,
          color: context.theme.appColors.secondaryBackground,
        ),
      ),
      lastMessageAt: conversation.latestMessage?.createdAt ?? conversation.joinedAt,
      lastMessageContent: conversation.latestMessage?.content ?? context.i18n.empty_message_history,
      unreadMessagesCount: unreadMessagesCount.valueOrNull ?? 0,
      onTap: () {
        ConversationRoute(conversationId: conversation.conversationId).push<void>(context);
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

    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);

    final receiverPukeyKey =
        entity.relatedPubkeys?.firstWhere((p) => p.value != currentUserPubkey).value;

    if (receiverPukeyKey == null) {
      return const SizedBox.shrink();
    }

    final userMetadata = ref.watch(userMetadataProvider(receiverPukeyKey)).valueOrNull;

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    final unreadMessagesCount =
        ref.watch(getUnreadMessagesCountProvider(conversation.conversationId));

    return RecentChatTile(
      conversation: conversation,
      name: userMetadata.data.displayName,
      avatarUrl: userMetadata.data.picture,
      defaultAvatar: null,
      lastMessageAt: conversation.latestMessage?.createdAt ?? conversation.joinedAt,
      lastMessageContent: conversation.latestMessage?.content ?? '',
      unreadMessagesCount: unreadMessagesCount.valueOrNull ?? 0,
      onTap: () {
        ConversationRoute(receiverPubKey: receiverPukeyKey).push<void>(context);
      },
    );
  }
}

class EncryptedGroupRecentChatTile extends HookConsumerWidget {
  const EncryptedGroupRecentChatTile({required this.conversation, super.key});

  final ConversationListItem conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (conversation.latestMessage == null) {
      return const SizedBox.shrink();
    }

    final entity = PrivateDirectMessageData.fromEventMessage(conversation.latestMessage!);

    final name = entity.relatedSubject?.value ?? '';

    final unreadMessagesCount =
        ref.watch(getUnreadMessagesCountProvider(conversation.conversationId));

    final groupImageFile = useFuture(
      ref.watch(mediaEncryptionServiceProvider).retreiveEncryptedMedia([
        entity.primaryMedia!,
      ]),
    ).data?.firstOrNull;

    return RecentChatTile(
      conversation: conversation,
      name: name,
      avatarWidget: groupImageFile != null ? Image.file(groupImageFile) : null,
      defaultAvatar: Assets.svg.iconChannelEmptychannel.icon(size: 40.0.s),
      lastMessageAt: conversation.latestMessage?.createdAt ?? conversation.joinedAt,
      lastMessageContent:
          entity.content.isEmpty ? context.i18n.empty_message_history : entity.content,
      unreadMessagesCount: unreadMessagesCount.valueOrNull ?? 0,
      onTap: () {
        ConversationRoute(conversationId: conversation.conversationId).push<void>(context);
      },
    );
  }
}
