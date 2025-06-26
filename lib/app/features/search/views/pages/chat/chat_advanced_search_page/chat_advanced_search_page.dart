// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/components/section_separator/section_separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.r.dart';
import 'package:ion/app/features/search/model/advanced_search_category.dart';
import 'package:ion/app/features/search/views/components/advanced_search_channels/advanced_search_channels.dart';
import 'package:ion/app/features/search/views/components/advanced_search_groups/advanced_search_groups.dart';
import 'package:ion/app/features/search/views/components/advanced_search_navigation/advanced_search_navigation.dart';
import 'package:ion/app/features/search/views/components/advanced_search_tab_bar/advanced_search_tab_bar.dart';
import 'package:ion/app/features/search/views/pages/chat/chat_advanced_search_page/components/chat_advanced_search_all/chat_advanced_search_all.dart';
import 'package:ion/app/features/search/views/pages/chat/chat_advanced_search_page/components/chat_advanced_search_chats/chat_advanced_search_chats.dart';
import 'package:ion/app/features/search/views/pages/chat/chat_advanced_search_page/components/chat_advanced_search_people/chat_advanced_search_people.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class ChatAdvancedSearchPage extends HookConsumerWidget {
  const ChatAdvancedSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideCommunity =
        ref.watch(featureFlagsProvider.notifier).get(ChatFeatureFlag.hideCommunity);

    final categories = useMemoized(
      () {
        return AdvancedSearchCategory.values
            .where(
              (category) => category.isChat && (!hideCommunity || !category.isCommunity),
            )
            .toList();
      },
      [hideCommunity],
    );

    return Scaffold(
      body: ScreenTopOffset(
        child: DefaultTabController(
          length: categories.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdvancedSearchNavigation(
                query: query,
                onTapSearch: () {
                  ChatQuickSearchRoute(query: query).push<void>(context);
                },
              ),
              SizedBox(height: 16.0.s),
              AdvancedSearchTabBar(categories: categories),
              const SectionSeparator(),
              Expanded(
                child: TabBarView(
                  children: categories.map((category) {
                    return switch (category) {
                      AdvancedSearchCategory.all => ChatAdvancedSearchAll(query: query),
                      AdvancedSearchCategory.people => ChatAdvancedSearchPeople(query: query),
                      AdvancedSearchCategory.chat => ChatAdvancedSearchChats(query: query),
                      AdvancedSearchCategory.groups => AdvancedSearchGroups(query: query),
                      AdvancedSearchCategory.channels => AdvancedSearchChannels(query: query),
                      _ => const SizedBox.shrink(),
                    };
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
