// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/user/pages/bookmarks_page/components/bookmarks_filters.dart';
import 'package:ion/app/features/user/pages/bookmarks_page/components/bookmarks_header.dart';
import 'package:ion/app/utils/future.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarksPage extends HookConsumerWidget {
  const BookmarksPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCollectionDTag = useState(BookmarksSetType.homeFeedCollectionsAll.dTagName);
    final rawQuery = useState<String>('');
    final query = useDebounced(rawQuery.value, 300.milliseconds) ?? '';
    final collectionEntityState = ref.watch(
      filteredBookmarksRefsProvider(
        collectionDTag: selectedCollectionDTag.value,
        query: query,
      ),
    );

    return Scaffold(
      appBar: BookmarksHeader(
        loading: collectionEntityState.isLoading && rawQuery.value.isNotEmpty,
        onSearchQueryUpdated: (value) => rawQuery.value = value.trim(),
      ),
      body: CustomScrollView(
        slivers: collectionEntityState.when(
          data: (refs) {
            return [
              SliverToBoxAdapter(
                child: BookmarksFilters(
                  activeCollectionDTag: selectedCollectionDTag.value,
                  onFilterTap: (collectionDTag) => selectedCollectionDTag.value = collectionDTag,
                ),
              ),
              SliverToBoxAdapter(child: FeedListSeparator()),
              if (refs.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyList(
                    asset: Assets.svg.walletIconEmptybookmraks,
                    title: context.i18n.bookmarks_empty_state,
                  ),
                )
              else
                EntitiesList(
                  refs: refs,
                  readFromDB: true,
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
