import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallets/pages/wallets_modal/components/wallets_list/wallets_list.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

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
            ScreenSideOffset.small(child: const WalletsList()),
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
