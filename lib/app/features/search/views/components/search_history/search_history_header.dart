// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/components/search_history_clear_confirm/search_history_clear_confirm.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class SearchHistoryHeader extends ConsumerWidget {
  const SearchHistoryHeader({required this.onClearHistory, super.key});

  final VoidCallback onClearHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: ScreenSideOffset.defaultSmallMargin),
          child: Text(
            context.i18n.feed_search_history_title,
            style: context.theme.appTextThemes.subtitle3.copyWith(
              color: context.theme.appColors.quaternaryText,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            final confirmed = await showSimpleBottomSheet<bool>(
                  context: context,
                  child: const SearchHistoryClearConfirm(),
                ) ??
                false;
            if (confirmed) {
              onClearHistory();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
            child: Assets.svgIconSheetClose.icon(size: 20.0.s),
          ),
        ),
      ],
    );
  }
}
