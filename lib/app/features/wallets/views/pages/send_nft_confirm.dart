// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network_fee_option.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/arrival_time/list_item_arrival_time.dart';
import 'package:ion/app/features/wallets/views/components/network_fee/list_item_network_fee.dart';
import 'package:ion/app/features/wallets/views/components/nft_item.dart';
import 'package:ion/app/features/wallets/views/send_to_recipient.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
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
    final formData = ref.watch(sendAssetFormControllerProvider(type: CryptoAssetType.nft));
    final nft = formData.assetData.as<NftAssetData>()!.nft;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.send_nft_navigation_title),
            actions: const [NavigationCloseButton()],
          ),
          ScreenSideOffset.small(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 10.0.s),
              child: Column(
                children: [
                  NftItem(nftData: nft),
                  SizedBox(height: 16.0.s),
                  SendToRecipient(
                    address: formData.receiverAddress,
                    pubkey: formData.contactPubkey,
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_title),
                    value: formData.wallet.name,
                    icon: Assets.svg.walletWalletblue.icon(
                      size: ScreenSideOffset.defaultSmallMargin,
                    ),
                    secondary: Align(
                      alignment: Alignment.centerRight,
                      // TODO: Remove hardcode
                      child: Text(
                        '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
                        textAlign: TextAlign.right,
                        style: context.theme.appTextThemes.caption3.copyWith(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0.s),
                  ListItem.textWithIcon(
                    title: Text(context.i18n.send_nft_confirm_network),
                    value: formData.network.name,
                    icon: Assets.svg.networks.walletEth.icon(size: 16.0.s),
                  ),
                  SizedBox(height: 12.0.s),
                  if (formData.selectedNetworkFeeOption case final NetworkFeeOption fee) ...[
                    if (fee.arrivalTime != null) ...[
                      ListItemArrivalTime(
                        feeOption: fee,
                      ),
                      SizedBox(height: 12.0.s),
                    ],
                    ListItemNetworkFee(
                      value: formatCrypto(fee.amount, fee.symbol),
                    ),
                  ],
                  SizedBox(height: 12.0.s),
                  Button(
                    mainAxisSize: MainAxisSize.max,
                    minimumSize: Size(56.0.s, 56.0.s),
                    label: Text(
                      context.i18n.button_confirm,
                    ),
                    onPressed: () {
                      NftTransactionResultRoute().go(context);
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
