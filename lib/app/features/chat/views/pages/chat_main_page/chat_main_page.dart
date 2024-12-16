// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/chat/recent_chats/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/components/recent_chat_skeleton/recent_chat_skeleton.dart';
import 'package:ion/app/features/chat/recent_chats/views/pages/recent_chats_empty_page/recent_chats_empty_page.dart';
import 'package:ion/app/features/chat/recent_chats/views/pages/recent_chats_timeline_page/recent_chats_timeline_page.dart';
import 'package:ion/app/features/chat/views/pages/chat_main_page/components/chat_main_appbar/chat_main_appbar.dart';

class ChatMainPage extends ConsumerWidget {
  const ChatMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: const ChatMainAppBar(),
      body: ScreenSideOffset.small(
        child: conversations.when(
          data: (data) {
            if (data.isEmpty) {
              return const RecentChatsEmptyPage();
            }
            return const RecentChatsTimelinePage();
          },
          loading: () {
            return const RecentChatSkeleton();
          },
          error: (_, __) {
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
