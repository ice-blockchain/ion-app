// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/modal_sheets/simple_modal_sheet.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ConfirmBookmarksCollectionDeletePopup extends ConsumerWidget {
  const ConfirmBookmarksCollectionDeletePopup({
    required this.data,
    super.key,
  });

  final BookmarksSetData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedBookmarkCollectionsNotifierProvider);
    ref.displayErrors(feedBookmarkCollectionsNotifierProvider);

    final buttonMinimalSize = Size(56.0.s, 56.0.s);

    return SimpleModalSheet.alert(
      isBottomSheet: true,
      iconAsset: Assets.svg.actionCreatepostDeletebookmarks,
      title: context.i18n.bookmarks_delete_collection_title,
      description: context.i18n.bookmarks_delete_collection_desc,
      bottomOffset: 0,
      button: ScreenSideOffset.small(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Button.compact(
                type: ButtonType.outlined,
                label: Text(context.i18n.button_cancel),
                onPressed: context.pop,
                minimumSize: buttonMinimalSize,
              ),
            ),
            SizedBox(width: 15.0.s),
            Expanded(
              child: Button.compact(
                disabled: state.isLoading,
                label: Text(context.i18n.button_delete),
                onPressed: () async {
                  await ref
                      .read(feedBookmarkCollectionsNotifierProvider.notifier)
                      .deleteCollection(data.type);
                  if (context.mounted) {
                    context.pop();
                  }
                },
                trailingIcon: state.isLoading ? const IONLoadingIndicator() : null,
                minimumSize: buttonMinimalSize,
                backgroundColor: context.theme.appColors.attentionRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
