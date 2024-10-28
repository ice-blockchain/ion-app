// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallet/components/wallets_list/wallets_list.dart';
import 'package:ion/app/features/wallets/pages/wallets_modal/components/wallets_list/wallet_tile.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class WalletsModal extends StatelessWidget {
  const WalletsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              showBackButton: false,
              title: Text(context.i18n.wallet_wallets),
              actions: const [NavigationCloseButton()],
            ),
            ScreenSideOffset.small(
              child: WalletsList(
                itemBuilder: (walletData) => WalletTile(walletData: walletData),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 16.0.s,
                top: 8.0.s,
                left: ScreenSideOffset.defaultSmallMargin,
                right: ScreenSideOffset.defaultSmallMargin,
              ),
              child: Button(
                leadingIcon: Assets.svg.iconButtonManageWallet.icon(),
                onPressed: () {
                  ManageWalletsRoute().push<void>(context);
                },
                label: Text(context.i18n.wallet_manage_wallets),
                mainAxisSize: MainAxisSize.max,
                type: ButtonType.secondary,
              ),
            ),
            SizedBox(height: 16.0.s),
          ],
        ),
      ),
    );
  }
}
