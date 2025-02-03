// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/coins/coin_icon.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/network_type.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/arrival_time/list_item_arrival_time.dart';
import 'package:ion/app/features/wallets/views/components/network_fee/list_item_network_fee.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/confirmation/transaction_amount_summary.dart';
import 'package:ion/app/features/wallets/views/send_to_recipient.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class ConfirmationSheet extends ConsumerWidget {
  const ConfirmationSheet({super.key});

  static const networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;

    final formData = ref.watch(sendAssetFormControllerProvider());

    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.s),
              child: NavigationAppBar.screen(
                title: Text(locale.wallet_send_coins),
                actions: const [
                  NavigationCloseButton(),
                ],
              ),
            ),
            ScreenSideOffset.small(
              child: Column(
                children: [
                  SizedBox(height: 16.0.s),
                  if (formData.selectedCoin case final CoinInWalletData coinInWallet)
                    TransactionAmountSummary(
                      amount: coinInWallet.amount,
                      currency: coinInWallet.coin.abbreviation,
                      usdAmount: coinInWallet.balanceUSD,
                      icon: CoinIconWidget(
                        imageUrl: coinInWallet.coin.iconUrl,
                        size: 36.0.s,
                      ),
                    ),
                  SizedBox(height: 16.0.s),
                  SendToRecipient(
                    address: formData.address,
                    pubkey: formData.selectedContactPubkey,
                  ),
                  if (formData.selectedCoin case final CoinData coin) ...[
                    SizedBox(height: 16.0.s),
                    ListItem.textWithIcon(
                      title: Text(locale.wallet_asset),
                      value: coin.name,
                      icon: CoinIconWidget(
                        imageUrl: coin.iconUrl,
                        size: ScreenSideOffset.defaultSmallMargin,
                      ),
                    ),
                  ],
                  SizedBox(height: 16.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_title),
                    value: formData.wallet.name,
                    icon: Assets.svg.walletWalletblue.icon(
                      size: ScreenSideOffset.defaultSmallMargin,
                    ),
                    secondary: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '0xf59B7547F254854F3f17a594Fe97b0aB24gf3023',
                        textAlign: TextAlign.right,
                        style: context.theme.appTextThemes.caption3.copyWith(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0.s),
                  ListItem.textWithIcon(
                    title: Text(locale.wallet_network),
                    value: formData.selectedNetwork.displayName,
                    icon: formData.selectedNetwork.svgIconAsset.icon(
                      size: 16.0.s,
                    ),
                  ),
                  SizedBox(height: 16.0.s),
                  ListItemArrivalTime(
                    arrivalTime: '${formData.arrivalTime} '
                        '${locale.wallet_arrival_time_minutes}',
                  ),
                  SizedBox(height: 16.0.s),
                  const ListItemNetworkFee(value: '1.00 USDT'),
                  SizedBox(height: 22.0.s),
                  if (formData.price != null)
                    Button(
                      label:
                          Text('${locale.button_confirm} - ${formatToCurrency(formData.price!)}'),
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () => CoinTransactionResultRoute().go(context),
                    ),
                  SizedBox(height: 16.0.s),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
