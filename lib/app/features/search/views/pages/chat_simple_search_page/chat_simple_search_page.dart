// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/search/providers/chat_search_history_provider.c.dart'
    show chatSearchHistoryProvider;
import 'package:ion/app/features/search/providers/chat_simple_search_provider.c.dart';
import 'package:ion/app/features/search/views/components/feed_search_history/feed_search_history_user_list_item.dart';
import 'package:ion/app/features/search/views/components/search_history/search_history.dart';
import 'package:ion/app/features/search/views/components/search_history_empty/search_history_empty.dart';
import 'package:ion/app/features/search/views/components/search_navigation/search_navigation.dart';
import 'package:ion/app/features/search/views/components/search_results_skeleton/search_results_skeleton.dart';
import 'package:ion/app/features/search/views/pages/chat_simple_search_page/components/search_results/chat_search_results.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/future.dart';
import 'package:ion/generated/assets.gen.dart';

class ChatSimpleSearchPage extends HookConsumerWidget {
  const ChatSimpleSearchPage(this.query, {super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(chatSearchHistoryProvider);

    final debouncedText = useDebounced<String>(query, 300.milliseconds) ?? '';

    final simpleSearchResults = ref.watch(chatSimpleSearchProvider(debouncedText));

    final hideCommunity =
        ref.watch(featureFlagsProvider.notifier).get(ChatFeatureFlag.hideCommunity);

    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            SearchNavigation(
              query: query,
              loading: simpleSearchResults.isLoading,
              onSubmitted: (String query) {
                ChatAdvancedSearchRoute(query: query).go(context);
                ref.read(chatSearchHistoryProvider.notifier).addQueryToTheHistory(query);
              },
              onTextChanged: (String text) => ChatSimpleSearchRoute(query: text).replace(context),
            ),
            simpleSearchResults.maybeWhen(
              data: (masterPubkeys) => masterPubkeys == null
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
                              ChatSimpleSearchRoute(query: text).replace(context),
                          onClearHistory: ref.read(chatSearchHistoryProvider.notifier).clear,
                          itemBuilder: (context, index) =>
                              FeedSearchHistoryUserListItem(pubkey: masterPubkeys![index]),
                        )
                  : masterPubkeys.isEmpty
                      ? const _NoResults()
                      : ChatSimpleSearchResults(masterPubkeys: masterPubkeys),
              orElse: SearchResultsSkeleton.new,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.s),
        child: EmptyList(
          asset: Assets.svg.walletIconWalletEmptysearch,
          title: context.i18n.core_empty_search,
        ),
      ),
    );
  }
}
