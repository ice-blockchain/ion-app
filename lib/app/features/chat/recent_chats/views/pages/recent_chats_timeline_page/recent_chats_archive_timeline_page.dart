// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/features/chat/providers/conversations_provider.c.dart';
import 'package:ion/app/features/chat/recent_chats/views/pages/recent_chats_timeline_page/recent_chats_timeline_page.dart';
import 'package:ion/app/router/app_routes.c.dart';

class RecentChatsArchiveTimelinePage extends ConsumerWidget {
  const RecentChatsArchiveTimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversations = ref.watch(archivedConversationsProvider).valueOrNull;

    if (conversations == null) {
      return const SizedBox.shrink();
    }

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => ChatQuickSearchRoute().push<void>(context),
              child: const IgnorePointer(
                child: SearchInput(),
              ),
            ),
          ),
          toolbarHeight: SearchInput.height,
        ),
        const SliverToBoxAdapter(
          child: HorizontalSeparator(),
        ),
        ConversationList(conversations: conversations),
      ],
    );
  }
}
