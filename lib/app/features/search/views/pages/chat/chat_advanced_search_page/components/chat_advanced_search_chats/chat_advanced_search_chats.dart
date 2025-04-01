// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/pages/chat/chat_advanced_search_page/components/chat_advanced_search_chats/chat_advanced_search_chat_list_item.dart';

class ChatAdvancedSearchChats extends HookConsumerWidget {
  const ChatAdvancedSearchChats({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (index == 0)
              SizedBox(
                height: 12.0.s,
              ),
            const ChatAdvancedSearchChatListItem(
              avatarUrl: 'https://picsum.photos/200',
              displayName: 'John Doe',
              message: 'Hello, how are you?',
            ),
            HorizontalSeparator(
              height: 16.0.s,
            ),
          ],
        );
      },
    );
  }
}
