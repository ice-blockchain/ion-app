import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/my_ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallets/pages/manage_wallets_modal/components/manage_wallets_list/manage_wallets_list.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/my_app_routes.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class ManageWalletsModal extends MyIcePage {
  const ManageWalletsModal({super.key});

  // const ManageWalletsModal(super.route, super.payload, {super.key});

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
  ) {
    return SheetContentScaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            NavigationAppBar.modal(
              title: context.i18n.wallet_manage_wallets,
              actions: const <Widget>[NavigationCloseButton()],
            ),
            SizedBox(
              height: 9.0.s,
            ),
            ScreenSideOffset.small(
              child: Button(
                leadingIcon: Assets.images.icons.iconButtonAddstroke
                    .icon(color: context.theme.appColors.onPrimaryAccent),
                onPressed: () {
                  // IceRoutes.createWallet.push(context);
                  const CreateWalletRoute().push<void>(context);
                },
                label: Text(context.i18n.wallet_create_new),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
            ScreenSideOffset.small(child: const ManageWalletsList()),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.0.s),
          ],
        ),
      ),
    );
  }
}
