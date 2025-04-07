// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/search/providers/chat_search_history_provider.c.dart'
    show chatSearchHistoryProvider;
import 'package:ion/app/features/search/providers/chat_users_search_provider.c.dart';
import 'package:ion/app/features/search/views/components/feed_search_history/feed_search_history_user_list_item.dart';
import 'package:ion/app/features/search/views/components/search_history/search_history.dart';
import 'package:ion/app/features/search/views/components/search_history_empty/search_history_empty.dart';
import 'package:ion/app/features/search/views/components/search_navigation/search_navigation.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_no_results_found.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_search_results.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_search_results_skeleton.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/future.dart';

class ChatQuickSearchPage extends HookConsumerWidget {
  const ChatQuickSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(chatSearchHistoryProvider);

    final debouncedText = useDebounced<String>(query, 300.milliseconds) ?? '';
    final usersSearchResults = ref.watch(chatUsersSearchProvider(debouncedText));

    final hideCommunity =
        ref.watch(featureFlagsProvider.notifier).get(ChatFeatureFlag.hideCommunity);

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
              onTextChanged: (String text) => ChatQuickSearchRoute(query: text).replace(context),
            ),
            usersSearchResults.maybeWhen(
              data: (pubkeysAndContentTuples) {
                return pubkeysAndContentTuples == null
                    ? history.pubKeys.isEmpty && history.queries.isEmpty
                        ? SearchHistoryEmpty(
                            title: hideCommunity
                                ? context.i18n.chat_search_no_community_empty
                                : context.i18n.chat_search_empty,
                          )
                        : SearchHistory(
                            queries: history.queries,
                            itemCount: history.pubKeys.length,
                            onSelectQuery: (String text) =>
                                ChatQuickSearchRoute(query: text).replace(context),
                            onClearHistory: ref.read(chatSearchHistoryProvider.notifier).clear,
                            itemBuilder: (context, index) => FeedSearchHistoryUserListItem(
                              pubkey: history.pubKeys[index],
                            ),
                          )
                    : pubkeysAndContentTuples.isEmpty
                        ? const Expanded(child: ChatSearchNoResults())
                        : Expanded(
                            child:
                                ChatSearchResults(pubkeysAndContentTuples: pubkeysAndContentTuples),
                          );
              },
              orElse: ChatSearchResultsSkeleton.new,
            ),
          ],
        ),
      ),
    );
  }
}
