import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_history_provider.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/components/feed_search_history/feed_search_history_clear_confirm.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedSearchHistoryHeader extends ConsumerWidget {
  const FeedSearchHistoryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: ScreenSideOffset.defaultSmallMargin),
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
                  child: const FeedSearchHistoryClearConfirm(),
                ) ??
                false;
            if (confirmed) {
              await ref.read(feedSearchHistoryProvider.notifier).clear();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
            child: Assets.svg.iconSheetClose.icon(size: 20.0.s),
          ),
        ),
      ],
    );
  }
}
