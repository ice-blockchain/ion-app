// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/feed_search/providers/feed_search_users_provider.dart';
import 'package:ion/app/features/feed/feed_search/views/components/nothing_is_found.dart';
import 'package:ion/app/features/feed/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_users/feed_advanced_search_user_list_item.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/components/post_list/post_list_skeleton.dart';

class FeedAdvancedSearchUsers extends HookConsumerWidget {
  const FeedAdvancedSearchUsers({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final usersSearchResults = ref.watch(feedSearchUsersProvider(query));

    return usersSearchResults.maybeWhen(
      data: (userIds) {
        if (userIds == null || userIds.isEmpty) {
          return const NothingIsFound();
        }

        return ListView.separated(
          itemCount: userIds.length,
          itemBuilder: (context, index) => FeedAdvancedSearchUserListItem(userId: userIds[index]),
          separatorBuilder: (_, __) => FeedListSeparator(),
        );
      },
      orElse: () => const CustomScrollView(slivers: [PostListSkeleton()]),
    );
  }
}
