// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/chat-v2/community/providers/community_join_requests_provider.c.dart';
import 'package:ion/app/features/chat-v2/community/providers/community_messages_subscriber_provider.c.dart';
import 'package:ion/app/features/chat-v2/e2ee/providers/e2ee_messages_subscriber.c.dart';
import 'package:ion/app/features/chat-v2/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat-v2/recent_chats/views/components/recent_chat_skeleton/recent_chat_skeleton.dart';
import 'package:ion/app/features/chat-v2/recent_chats/views/pages/recent_chats_empty_page/recent_chats_empty_page.dart';
import 'package:ion/app/features/chat-v2/recent_chats/views/pages/recent_chats_timeline_page/recent_chats_timeline_page.dart';
import 'package:ion/app/features/chat-v2/views/pages/chat_main_page/components/chat_main_appbar/chat_main_appbar.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class ChatMainPage extends HookConsumerWidget {
  const ChatMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useOnInit(() {
      ref.read(communityJoinRequestsProvider);
    });

    final e2eeMessagesSubscriber = ref.watch(e2eeMessagesSubscriberProvider);
    final communityMessagesSubscriber = ref.watch(communityMessagesSubscriberProvider);
    final conversations = ref.watch(conversationsProvider);

    final isLoading = useMemoized(
        () => e2eeMessagesSubscriber.isLoading || communityMessagesSubscriber.isLoading, [
      e2eeMessagesSubscriber.isLoading,
      communityMessagesSubscriber.isLoading,
    ]);

    return Scaffold(
      appBar: const ChatMainAppBar(),
      body: ScreenSideOffset.small(
        child: isLoading
            ? const RecentChatSkeleton()
            : conversations.when(
                data: (data) {
                  if (data.isEmpty) {
                    return const RecentChatsEmptyPage();
                  }
                  return RecentChatsTimelinePage(conversations: data);
                },
                error: (error, stackTrace) => const SizedBox(),
                loading: () => const RecentChatSkeleton(),
              ),
      ),
    );
  }
}
