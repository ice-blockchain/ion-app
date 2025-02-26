// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/features/search/views/pages/chat_advanced_search_page/components/chat_advanced_search_users/chat_advanced_search_user_list_item.dart';
import 'package:ion/app/features/user/providers/search_users_provider.c.dart';

class ChatAdvancedSearchUsers extends HookConsumerWidget {
  const ChatAdvancedSearchUsers({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final usersSearchResults = ref.watch(searchUsersProvider(query: query));

    return usersSearchResults.maybeWhen(
      data: (data) {
        if (data.users.isEmpty) {
          return NothingIsFound(
            title: context.i18n.core_empty_search,
          );
        }

        return ListView.builder(
          itemCount: data.users.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                if (index == 0)
                  SizedBox(
                    height: 12.0.s,
                  ),
                ChatAdvancedSearchUserListItem(user: data.users[index]),
                HorizontalSeparator(
                  height: 16.0.s,
                ),
              ],
            );
          },
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
