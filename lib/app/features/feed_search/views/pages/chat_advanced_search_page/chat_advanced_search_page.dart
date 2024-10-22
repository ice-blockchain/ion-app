// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed_search/model/advanced_search_category.dart';
import 'package:ion/app/features/feed_search/views/components/advanced_search_navigation/advanced_search_navigation.dart';
import 'package:ion/app/features/feed_search/views/components/advanced_search_tab_bar/advanced_search_tab_bar.dart';
import 'package:ion/app/features/feed_search/views/pages/chat_advanced_search_page/components/chat_advanced_search_users/chat_advanced_search_users.dart';
import 'package:ion/app/router/app_routes.dart';

class ChatAdvancedSearchPage extends HookConsumerWidget {
  const ChatAdvancedSearchPage({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = useMemoized(
      () {
        return AdvancedSearchCategory.values.where((category) => category.isChat).toList();
      },
      [],
    );

    return Scaffold(
      body: ScreenTopOffset(
        child: DefaultTabController(
          length: AdvancedSearchCategory.values.length,
          child: Column(
            children: [
              AdvancedSearchNavigation(
                query: query,
                onTapSearch: () {
                  ChatSimpleSearchRoute(query: query).push<void>(context);
                },
              ),
              SizedBox(height: 16.0.s),
              AdvancedSearchTabBar(
                categories: categories,
              ),
              FeedListSeparator(),
              Expanded(
                child: TabBarView(
                  children: categories.map((category) {
                    return switch (category) {
                      AdvancedSearchCategory.people => ChatAdvancedSearchUsers(query: query),
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
