// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/features/chat/providers/mock.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_seperator/recent_chat_seperator.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_tile/recent_chat_tile.dart';

class RecentChatsTimelinePage extends StatelessWidget {
  const RecentChatsTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: const FlexibleSpaceBar(
            background: SearchInput(),
          ),
          toolbarHeight: SearchInput.height,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final conversation = mockConversationData[index];
              return Column(
                children: [
                  if (index == 0)
                    const RecentChatSeparator(
                      isAtTop: true,
                    ),
                  RecentChatTile(conversation),
                  const RecentChatSeparator(),
                ],
              );
            },
            childCount: mockConversationData.length,
          ),
        ),
      ],
    );
  }
}
