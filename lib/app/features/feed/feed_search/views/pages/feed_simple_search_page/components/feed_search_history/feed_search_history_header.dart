import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedSearchHistoryHeader extends ConsumerWidget {
  const FeedSearchHistoryHeader();

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
            final res = await showSimpleBottomSheet<int>(
              context: context,
              child: _ClearHistoryConfirm(),
            );
            print('res => $res');
            // ref.read(feedSearchHistoryProvider.notifier).clear();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
            child: Assets.svg.iconSheetClose.icon(size: 20.0.s),
          ),
        )
      ],
    );
  }
}

class _ClearHistoryConfirm extends StatelessWidget {
  const _ClearHistoryConfirm();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0.s),
      child: Column(
        children: [
          SizedBox(height: 30.0.s),
          InfoCard(
            iconAsset: Assets.svg.actionWalletSecureaccount,
            title: context.i18n.protect_account_title_secure_account,
            description: context.i18n.protect_account_description_secure_account,
          ),
          SizedBox(height: 32.0.s),
          Button(
            mainAxisSize: MainAxisSize.max,
            leadingIcon: Assets.svg.iconWalletProtectAccount.icon(
              color: context.theme.appColors.onPrimaryAccent,
            ),
            label: Text(context.i18n.protect_account_button),
            onPressed: () => Navigator.pop(context, 1),
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
