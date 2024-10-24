// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/pages/chat_advanced_search_page/components/chat_advanced_search_chats/chat_advanced_search_chat_list_item.dart';

class ChatSearchResults extends ConsumerWidget {
  const ChatSearchResults({
    required this.pubKeys,
    super.key,
  });

  static double get listVerticalOffset => 14.0.s;

  final List<String> pubKeys;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: listVerticalOffset),
        itemCount: pubKeys.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 16.0.s);
        },
        itemBuilder: (context, index) {
          return const ChatAdvancedSearchChatListItem(
            avatarUrl: 'https://picsum.photos/200',
            displayName: 'John Doe',
            message: 'Hello, how are you?',
          );
        },
      ),
    );
  }
}
