// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_seperator/recent_chat_seperator.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/archive_chat_tile.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';
import 'package:ion/app/router/app_routes.c.dart';

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
              if (conversation.isArchived) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  if (index == 0 && !showArchive) const RecentChatSeparator(isAtTop: true),
                  RecentChatTile(conversation),
                  const RecentChatSeparator(),
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
