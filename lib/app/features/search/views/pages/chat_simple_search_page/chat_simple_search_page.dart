// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/nothing_is_found/nothing_is_found.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/search/providers/chat_search_history_provider.c.dart'
    show chatSearchHistoryProvider;
import 'package:ion/app/features/search/providers/chat_search_users_provider.c.dart';
import 'package:ion/app/features/search/views/components/feed_search_history/feed_search_history_user_list_item.dart';
import 'package:ion/app/features/search/views/components/search_history/search_history.dart';
import 'package:ion/app/features/search/views/components/search_history_empty/search_history_empty.dart';
import 'package:ion/app/features/search/views/components/search_navigation/search_navigation.dart';
import 'package:ion/app/features/search/views/components/search_results_skeleton/search_results_skeleton.dart';
import 'package:ion/app/features/search/views/pages/chat_simple_search_page/components/search_results/chat_search_results.dart';
import 'package:ion/app/router/app_routes.c.dart';

class ChatSimpleSearchPage extends ConsumerWidget {
  const ChatSimpleSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(chatSearchHistoryProvider);
    final usersSearchResults = ref.watch(chatSearchUsersProvider(query));

    final hideCommunity =
        ref.watch(featureFlagsProvider.notifier).get(HideCommunityFeatureFlag.hideCommunity);

    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            SearchNavigation(
              query: query,
              loading: usersSearchResults.isLoading,
              onSubmitted: (String query) {
                ChatAdvancedSearchRoute(query: query).go(context);
                ref.read(chatSearchHistoryProvider.notifier).addQueryToTheHistory(query);
              },
              onTextChanged: (String text) {
                ChatSimpleSearchRoute(query: text).replace(context);
              },
            ),
            usersSearchResults.maybeWhen(
              data: (pubKeys) => pubKeys == null
                  ? history.pubKeys.isEmpty && history.queries.isEmpty
                      ? SearchHistoryEmpty(
                          title: hideCommunity
                              ? context.i18n.chat_search_no_community_empty
                              : context.i18n.chat_search_empty,
                        )
                      : SearchHistory(
                          itemCount: history.pubKeys.length,
                          queries: history.queries,
                          onSelectQuery: (String query) {
                            ChatSimpleSearchRoute(query: query).replace(context);
                          },
                          onClearHistory: () {
                            ref.read(chatSearchHistoryProvider.notifier).clear();
                          },
                          itemBuilder: (context, index) =>
                              FeedSearchHistoryUserListItem(pubkey: pubKeys![index]),
                        )
                  : pubKeys.isEmpty
                      ? const NothingIsFound()
                      : ChatSearchResults(pubKeys: pubKeys),
              orElse: SearchResultsSkeleton.new,
            ),
          ],
        ),
      ),
    );
  }
}
