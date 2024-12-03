// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/tabs/tabs_header_tab.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/providers/search_visibility_provider.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class WalletTabsHeader extends ConsumerWidget {
  const WalletTabsHeader({
    required this.activeTab,
    required this.onTabSwitch,
    super.key,
  });

  final WalletTabType activeTab;
  final void Function(WalletTabType newTab) onTabSwitch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchVisibleProvider = walletSearchVisibilityProvider(activeTab);
    return Padding(
      padding: EdgeInsets.only(
        top: 16.0.s - UiConstants.hitSlop,
        left: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
        right: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WalletTabsHeaderTab(
            isActive: activeTab == WalletTabType.coins,
            title: WalletTabType.coins.getTitle(context),
            onTap: () => onTabSwitch(WalletTabType.coins),
          ),
          SizedBox(
            width: 20.0.s - UiConstants.hitSlop * 2,
          ),
          WalletTabsHeaderTab(
            isActive: activeTab == WalletTabType.nfts,
            title: WalletTabType.nfts.getTitle(context),
            onTap: () => onTabSwitch(WalletTabType.nfts),
          ),
          WalletTabsHeaderTab(
            isActive: false,
            title: context.i18n.core_dapps,
            onTap: () => DAppsRoute().push<void>(context),
          ),
          const Spacer(),
          //const WalletTabsHeaderHideAction(),
          TextButton(
            onPressed: () {
              ref.read(searchVisibleProvider.notifier).isVisible = true;
            },
            child: Padding(
              padding: EdgeInsets.all(UiConstants.hitSlop),
              child: Assets.svg.iconFieldSearch.icon(
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
