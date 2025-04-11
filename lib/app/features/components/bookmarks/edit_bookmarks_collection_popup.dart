// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/bookmarks/bookmarks_collection_name_popup.dart';

class EditBookmarksCollectionPopup extends HookConsumerWidget {
  const EditBookmarksCollectionPopup({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: watch collection name and update in onAction
    // TODO: ref.displayErrors
    return BookmarksCollectionNamePopup(
      onAction: () async {},
      initialValue: 'collectionName',
      action: context.i18n.button_save,
      title: context.i18n.bookmarks_edit_collection_title,
      desc: context.i18n.bookmarks_edit_collection_desc,
    );
  }
}
