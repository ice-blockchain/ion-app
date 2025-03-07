// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/search/views/pages/feed_advanced_search_page/components/feed_advanced_search_users/feed_advanced_search_user_list_item.dart';
import 'package:ion/app/features/user/providers/search_users_provider.c.dart';

class FeedAdvancedSearchUsers extends HookConsumerWidget {
  const FeedAdvancedSearchUsers({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final searchResults = ref.watch(searchUsersProvider(query: query));

    return PullToRefreshBuilder(
      slivers: [
        if (searchResults == null)
          const ListItemsLoadingState(
            padding: EdgeInsets.zero,
            listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
          )
        else if (searchResults.users.isEmpty && !searchResults.hasMore)
          NothingIsFound(title: context.i18n.search_nothing_found)
        else
          SliverList.separated(
            itemCount: searchResults.users.length,
            separatorBuilder: (_, __) => FeedListSeparator(),
            itemBuilder: (context, index) =>
                FeedAdvancedSearchUserListItem(user: searchResults.users[index]),
          ),
      ],
      onRefresh: ref.read(searchUsersProvider(query: query).notifier).refresh,
      builder: (context, slivers) => LoadMoreBuilder(
        slivers: slivers,
        onLoadMore: ref.read(searchUsersProvider(query: query).notifier).loadMore,
        hasMore: searchResults?.hasMore ?? false,
      ),
    );
  }
}
