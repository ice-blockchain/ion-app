// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/components/advanced_search_groups/advanced_search_group_list_item.dart';
import 'package:ion/app/features/search/views/pages/chat_advanced_search_page/components/chat_advanced_search_chats/chat_advanced_search_chat_list_item.dart';

class ChatAdvancedSearchAll extends HookConsumerWidget {
  const ChatAdvancedSearchAll({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(top: 4.0.s, bottom: 8.0.s),
          child: const HorizontalSeparator(),
        ),
        HorizontalSeparator(
          height: 16.0.s,
        ),
        const ChatAdvancedSearchChatListItem(
          avatarUrl: 'https://i.pravatar.cc/150?u=@felixx',
          displayName: 'Mike Crypto',
          message: 'Are you sure? I haven’t heard of.',
        ),
        HorizontalSeparator(
          height: 16.0.s,
        ),
        const ChatAdvancedSearchChatListItem(
          avatarUrl: 'https://i.pravatar.cc/150?u=@sarahs',
          displayName: 'Sarah Ash',
          message: 'I am not sure, but I think it is.',
        ),
        HorizontalSeparator(
          height: 16.0.s,
        ),
        const AdvancedSearchGroupListItem(
          avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
          displayName: 'HOT Crypto Updates',
          message: 'Interesting statistics on the mass distribution of cryptocurrencies.',
          joined: false,
          isVerified: true,
        ),
        HorizontalSeparator(
          height: 16.0.s,
        ),
        const AdvancedSearchGroupListItem(
          avatarUrl: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
          displayName: 'HOT Crypto Updates',
          message: '10,000',
          joined: true,
          isION: true,
        ),
      ],
    );
  }
}
