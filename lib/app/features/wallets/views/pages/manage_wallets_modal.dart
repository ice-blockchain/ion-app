// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/views/components/manage_wallet_tile.dart';
import 'package:ion/app/features/wallets/views/components/wallets_list.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageWalletsModal extends StatelessWidget {
  const ManageWalletsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              title: Text(context.i18n.wallet_manage_wallets),
              actions: const [
                NavigationCloseButton(),
              ],
            ),
            SizedBox(
              height: 9.0.s,
            ),
            ScreenSideOffset.small(
              child: Button(
                leadingIcon: Assets.svg.iconButtonAddstroke
                    .icon(color: context.theme.appColors.onPrimaryAccent),
                onPressed: () {
                  CreateWalletRoute().push<void>(context);
                },
                label: Text(context.i18n.wallet_create_new),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            ScreenSideOffset.small(
              child: WalletsList(
                itemBuilder: (walletData) => ManageWalletTile(walletViewId: walletData.id),
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.0.s),
          ],
        ),
      ),
    );
  }
}
