// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/search/providers/feed_search_users_provider.dart';
import 'package:ion/app/features/search/views/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/features/search/views/pages/feed_advanced_search_page/components/feed_advanced_search_users/feed_advanced_search_user_list_item.dart';

class FeedAdvancedSearchUsers extends HookConsumerWidget {
  const FeedAdvancedSearchUsers({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final usersSearchResults = ref.watch(feedSearchUsersProvider(query));

    return usersSearchResults.maybeWhen(
      data: (pubKeys) {
        if (pubKeys == null || pubKeys.isEmpty) {
          return NothingIsFound(
            title: context.i18n.search_nothing_found,
          );
        }

        return ListView.separated(
          itemCount: pubKeys.length,
          itemBuilder: (context, index) => FeedAdvancedSearchUserListItem(pubKey: pubKeys[index]),
          separatorBuilder: (_, __) => FeedListSeparator(),
        );
      },
      orElse: () => const CustomScrollView(slivers: [EntitiesListSkeleton()]),
    );
  }
}
