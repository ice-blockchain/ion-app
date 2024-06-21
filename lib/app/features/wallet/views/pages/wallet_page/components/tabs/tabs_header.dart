import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/tabs_header_hide_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/tabs_header_tab.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/generated/assets.gen.dart';

class WalletTabsHeader extends HookConsumerWidget {
  const WalletTabsHeader({
    required this.activeTab,
    required this.onTabSwitch,
    super.key,
  });

  final WalletTabType activeTab;
  final void Function(WalletTabType newTab) onTabSwitch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        top: UiSize.large - UiConstants.hitSlop,
        left: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
        right: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          WalletTabsHeaderTab(
            isActive: activeTab == WalletTabType.coins,
            tabType: WalletTabType.coins,
            onTap: () => onTabSwitch(WalletTabType.coins),
          ),
          SizedBox(
            width: 20.0.s - UiConstants.hitSlop * 2,
          ),
          WalletTabsHeaderTab(
            isActive: activeTab == WalletTabType.nfts,
            tabType: WalletTabType.nfts,
            onTap: () => onTabSwitch(WalletTabType.nfts),
          ),
          const Spacer(),
          const WalletTabsHeaderHideAction(),
          TextButton(
            onPressed: () {
              ref.read(walletPageNotifierProvider.notifier).updateSearchVisible(
                    tabType: activeTab,
                    isSearchVisible: true,
                  );
            },
            child: Padding(
              padding: EdgeInsets.all(UiConstants.hitSlop),
              child: Assets.images.icons.iconFieldSearch.icon(
                color: context.theme.appColors.tertararyText,
                size: 20.0.s,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
