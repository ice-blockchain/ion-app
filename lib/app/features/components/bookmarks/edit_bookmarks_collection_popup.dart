// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/bookmarks/bookmarks_collection_name_popup.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';

class EditBookmarksCollectionPopup extends HookConsumerWidget {
  const EditBookmarksCollectionPopup({
    required this.data,
    super.key,
  });

  final BookmarksSetData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.displayErrors(feedBookmarkCollectionsNotifierProvider);

    return BookmarksCollectionNamePopup(
      onAction: (collectionName) async {
        await ref
            .read(feedBookmarkCollectionsNotifierProvider.notifier)
            .renameCollection(data, collectionName);
      },
      initialValue: data.title,
      action: context.i18n.button_save,
      title: context.i18n.bookmarks_edit_collection_title,
      desc: context.i18n.bookmarks_edit_collection_desc,
    );
  }
}
