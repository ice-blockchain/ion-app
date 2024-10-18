// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/chat/providers/mock.dart';
import 'package:ice/app/features/chat/recent_chats/views/pages/recent_chats_empty_page/recent_chats_empty_page.dart';
import 'package:ice/app/features/chat/recent_chats/views/pages/recent_chats_timeline_page/recent_chats_timeline_page.dart';
import 'package:ice/app/features/chat/views/pages/chat_main_page/components/chat_main_appbar/chat_main_appbar.dart';

class ChatMainPage extends StatelessWidget {
  const ChatMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasConversations = mockConversationData.isNotEmpty;

    return Scaffold(
      appBar: const ChatMainAppBar(),
      body: ScreenSideOffset.small(
        child: hasConversations ? const RecentChatsTimelinePage() : const RecentChatsEmptyPage(),
      ),
    );
  }
}
