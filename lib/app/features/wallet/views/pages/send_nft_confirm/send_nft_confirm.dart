// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/components/nft_item/nft_item.dart';
import 'package:ion/app/features/wallet/components/send_to_recipient/send_to_recipient.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SendNftConfirmPage extends ConsumerWidget {
  const SendNftConfirmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final formData =
        ref.watch(sendAssetFormControllerProvider(type: CryptoAssetType.nft));
    final selectedNft = formData.selectedNft;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.send_nft_navigation_title),
            showBackButton: false,
            actions: const [NavigationCloseButton()],
          ),
          if (selectedNft != null)
            ScreenSideOffset.small(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 10.0.s),
                child: Column(
                  children: [
                    NftItem(nftData: selectedNft),
                    SizedBox(height: 16.0.s),
                    SendToRecipient(
                      address: formData.address,
                      contact: formData.selectedContact,
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(locale.wallet_title),
                      value: formData.wallet.name,
                      icon: Image.network(
                        formData.wallet.icon,
                        width: ScreenSideOffset.defaultSmallMargin,
                        height: ScreenSideOffset.defaultSmallMargin,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                      secondary: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
                          textAlign: TextAlign.right,
                          style:
                              context.theme.appTextThemes.caption3.copyWith(),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(context.i18n.send_nft_confirm_network),
                      value: selectedNft.network,
                      icon: Assets.images.wallet.walletEth.icon(size: 16.0.s),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(locale.wallet_arrival_time),
                      value: '${formData.arrivalTime} '
                          '${locale.wallet_arrival_time_minutes}',
                      icon: Assets.svg.iconBlockTime.icon(
                        size: 16.0.s,
                      ),
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem.textWithIcon(
                      title: Text(locale.wallet_network_fee),
                      value: '1.00 USDT',
                      icon: Assets.svg.iconBlockCoins.icon(
                        size: 16.0.s,
                      ),
                    ),
                    SizedBox(height: 12.0.s),
                    Button(
                      mainAxisSize: MainAxisSize.max,
                      minimumSize: Size(56.0.s, 56.0.s),
                      label: Text(
                        context.i18n.button_confirm,
                      ),
                      onPressed: () {
                        CoinTransactionResultRoute(
                          cryptoAssetType: CryptoAssetType.nft,
                        ).go(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
