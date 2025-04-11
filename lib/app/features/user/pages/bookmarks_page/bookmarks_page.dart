// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/user/pages/bookmarks_page/components/bookmarks_filters.dart';
import 'package:ion/app/features/user/pages/bookmarks_page/components/bookmarks_header.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarksPage extends HookConsumerWidget {
  const BookmarksPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksEntities = ref.watch(currentUserFeedBookmarksEntitiesProvider);
    return Scaffold(
      appBar: const BookmarksHeader(),
      body: CustomScrollView(
        slivers: bookmarksEntities.when(
          data: (data) {
            if (data.isNotEmpty) {
              return [
                const SliverToBoxAdapter(child: BookmarksFilters()),
                SliverToBoxAdapter(child: FeedListSeparator()),
                EntitiesList(
                  entities: data,
                ),
              ];
            }
            return [
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyList(
                  asset: Assets.svg.walletIconEmptybookmraks,
                  title: context.i18n.bookmarks_empty_state,
                ),
              ),
            ];
          },
          error: (error, stackTrace) => [const SliverFillRemaining(child: SizedBox())],
          loading: () => [const EntitiesListSkeleton()],
        ),
      ),
    );
  }
}
