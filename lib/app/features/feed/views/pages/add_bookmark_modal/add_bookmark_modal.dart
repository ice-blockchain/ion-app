// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/bookmarks/bookmarks_collection_tile.dart';
import 'package:ion/app/features/components/bookmarks/new_bookmarks_collection_button.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_collection.c.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class AddBookmarkModal extends ConsumerWidget {
  const AddBookmarkModal({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksCollections = ref.watch(feedBookmarkCollectionsNotifierProvider);
    return SheetContent(
      body: ScreenSideOffset.small(
        child: CustomScrollView(
          slivers: bookmarksCollections.when(
            data: (data) {
              final collectionsDTags = data
                  .map((eventReference) => eventReference.dTag)
                  .whereType<String>()
                  .where((dTag) => dTag != BookmarksCollectionEntity.defaultCollectionDTag)
                  .toList();
              return [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 24.0.s),
                      BookmarksCollectionTile(
                        eventReference: eventReference,
                        collectionDTag: BookmarksCollectionEntity.defaultCollectionDTag,
                      ),
                      SizedBox(height: 16.0.s),
                      const HorizontalSeparator(),
                      SizedBox(height: 16.0.s),
                    ],
                  ),
                ),
                SliverList.separated(
                  itemCount: collectionsDTags.length,
                  separatorBuilder: (BuildContext context, int index) => SizedBox(height: 16.0.s),
                  itemBuilder: (BuildContext context, int index) {
                    return BookmarksCollectionTile(
                      eventReference: eventReference,
                      collectionDTag: collectionsDTags[index],
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const NewBookmarksCollectionButton(),
                      SizedBox(height: 16.0.s),
                    ],
                  ),
                ),
              ];
            },
            error: (error, stackTrace) => [const SliverFillRemaining(child: SizedBox())],
            loading: () => [
              ListItemsLoadingState(
                itemHeight: 60.0.s,
                itemsCount: 3,
                listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
