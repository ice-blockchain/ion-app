import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/constants.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/tabs_header_hide_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/tabs_header_tab.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/generated/assets.gen.dart';

class WalletTabsHeader extends StatelessWidget {
  const WalletTabsHeader({
    super.key,
    required this.activeTab,
    required this.onTabSwitch,
  });

  final WalletTabType activeTab;
  final void Function(WalletTabType newTab) onTabSwitch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        ScreenSideOffset.defaultSmallMargin - Constants.hitSlop,
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
            width: 20.0.s - Constants.hitSlop * 2,
          ),
          WalletTabsHeaderTab(
            isActive: activeTab == WalletTabType.nfts,
            tabType: WalletTabType.nfts,
            onTap: () => onTabSwitch(WalletTabType.nfts),
          ),
          const Spacer(),
          const WalletTabsHeaderHideAction(),
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.all(Constants.hitSlop),
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
