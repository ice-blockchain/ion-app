// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_collection.c.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/generated/assets.gen.dart';

class BookmarksCollectionTileSelectAction extends ConsumerWidget {
  const BookmarksCollectionTileSelectAction({
    required this.data,
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;
  final BookmarksCollectionData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked =
        ref.watch(isBookmarkedInCollectionProvider(eventReference, collectionDTag: data.type));
    final bookmarkState = ref.watch(feedBookmarksNotifierProvider(collectionDTag: data.type));
    return GestureDetector(
      onTap: bookmarkState.isLoading
          ? null
          : () {
              ref
                  .read(feedBookmarksNotifierProvider(collectionDTag: data.type).notifier)
                  .toggleBookmark(eventReference);
            },
      child: _getIconWidget(isBookmarked),
    );
  }

  Widget? _getIconWidget(bool isBookmarked) {
    final isDefaultCollection = data.type == BookmarksCollectionEntity.defaultCollectionDTag;
    if (isDefaultCollection) {
      return isBookmarked ? Assets.svg.iconBookmarksOn.icon() : Assets.svg.iconBookmarks.icon();
    }
    return isBookmarked
        ? Assets.svg.iconBlockCheckboxOnblue.icon()
        : Assets.svg.iconBlockCheckboxOff.icon();
  }
}
