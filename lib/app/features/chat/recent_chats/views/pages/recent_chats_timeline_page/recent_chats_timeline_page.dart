// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/chat/e2ee/model/entites/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/unread_message_count_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/model/conversation_list_item.c.dart';
import 'package:ion/app/features/chat/recent_chats/providers/archived_conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_seperator/recent_chat_seperator.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/archive_chat_tile.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class RecentChatsTimelinePage extends HookConsumerWidget {
  const RecentChatsTimelinePage({required this.conversations, super.key});

  final List<ConversationListItem> conversations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnInit(() {
      ref.read(archivedConversationsProvider.notifier);
    });

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
        const SliverToBoxAdapter(child: RecentChatSeparator(isAtTop: true)),
        const SliverToBoxAdapter(child: ArchiveChatTile()),
        ConversationList(conversations: conversations.where((c) => !c.isArchived).toList()),
      ],
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
                key: ValueKey(conversation.uuid),
              )
            else if (conversation.type == ConversationType.oneToOne)
              E2eeRecentChatTile(
                conversation: conversation,
                key: ValueKey(conversation.uuid),
              )
            else if (conversation.type == ConversationType.encryptedGroup)
              EncryptedGroupRecentChatTile(
                conversation: conversation,
                key: ValueKey(conversation.uuid),
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
    final community = ref.watch(communityMetadataProvider(conversation.uuid)).valueOrNull;

    final unreadMessagesCount = ref.watch(unreadMessageCountProviderProvider(conversation.uuid));
    if (community == null) {
      return const SizedBox.shrink();
    }

    return RecentChatTile(
      conversation: conversation,
      name: community.data.name,
      avatarUrl: community.data.avatar?.url,
      defaultAvatar: Assets.svg.emptyChannel.icon(size: 40.0.s),
      lastMessageAt: conversation.latestMessage?.createdAt ?? conversation.joinedAt,
      lastMessageContent: conversation.latestMessage?.content ?? context.i18n.empty_message_history,
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
      conversation: conversation,
      name: userMetadata.data.displayName,
      avatarUrl: userMetadata.data.picture,
      defaultAvatar: null,
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

    final unreadMessagesCount = ref.watch(unreadMessageCountProviderProvider(conversation.uuid));

    final mediaService = useFuture(
      ref.watch(mediaServiceProvider).retreiveEncryptedMedia([
        entity.primaryMedia!,
      ]),
    );

    return RecentChatTile(
      conversation: conversation,
      name: name,
      avatarWidget:
          mediaService.data?.isNotEmpty ?? false ? Image.file(mediaService.data!.first) : null,
      defaultAvatar: Assets.svg.emptyChannel.icon(size: 40.0.s),
      lastMessageAt: conversation.latestMessage?.createdAt ?? conversation.joinedAt,
      lastMessageContent: entity.content.isEmpty
          ? context.i18n.empty_message_history
          : entity.content.map((e) => e.text).join(),
      unreadMessagesCount: unreadMessagesCount.valueOrNull ?? 0,
      onTap: () {
        ChannelRoute(uuid: conversation.uuid).push<void>(context);
      },
    );
  }
}
