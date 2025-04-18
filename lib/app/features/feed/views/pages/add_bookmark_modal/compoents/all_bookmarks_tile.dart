// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/bookmarks/bookmarks_collection_tile.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class AllBookmarksTile extends ConsumerWidget {
  const AllBookmarksTile({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(isFeedBookmarkedProvider(eventReference));
    final allBookmarksCollectionRefs =
        ref.watch(currentUserAllBookmarksCollectionRefsProvider).valueOrNull;
    final bookmarksAmount = allBookmarksCollectionRefs?.length ?? 0;

    ref.displayErrors(bookmarksNotifierProvider);

    return BookmarksCollectionTile(
      mode: BookmarksCollectionTileMode.main,
      isSelected: isBookmarked,
      collectionName: context.i18n.core_all,
      bookmarksAmount: bookmarksAmount,
    );
  }
}
