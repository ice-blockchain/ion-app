// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_seperator/recent_chat_seperator.dart';
import 'package:ion/app/router/app_routes.c.dart';

class RecentChatsTimelinePage extends ConsumerWidget {
  const RecentChatsTimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsProvider).valueOrNull;

    if (conversations == null) {
      return const SizedBox.shrink();
    }

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
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final conversation = conversations[index];
              return Column(
                children: [
                  if (index == 0)
                    const RecentChatSeparator(
                      isAtTop: true,
                    ),
                  Text(
                    '${conversation.data.relatedSubject ?? 'One-to-one'} ${conversation.data.content.isNotEmpty ? conversation.data.content : 'Initial'}',
                  ),
                  // TODO: Update RecentChatTile to use PrivateDirectMessageEntity
                  //RecentChatTile(conversation),
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
