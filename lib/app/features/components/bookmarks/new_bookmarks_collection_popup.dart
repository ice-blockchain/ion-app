// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/bookmarks/bookmarks_collection_name_popup.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';

class NewBookmarksCollectionPopup extends HookConsumerWidget {
  const NewBookmarksCollectionPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(feedBookmarkCollectionsNotifierProvider);

    return BookmarksCollectionNamePopup(
      onAction: (collectionName) async {
        await ref
            .read(feedBookmarkCollectionsNotifierProvider.notifier)
            .createCollection(collectionName);
      },
      action: context.i18n.bookmarks_create_collection,
      title: context.i18n.bookmarks_new_collection_title,
      desc: context.i18n.bookmarks_new_collection_desc,
    );
  }
}
