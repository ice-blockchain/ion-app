// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/balance/coin_usd_amount.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ion/app/router/app_routes.c.dart';

class Balance extends ConsumerWidget {
  const Balance({
    required this.coinsGroup,
    super.key,
  });

  final CoinsGroup coinsGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ScreenSideOffset.small(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 16.0.s),
            child: CoinUsdAmount(coinsGroup: coinsGroup),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(bottom: 20.0.s, top: 11.0.s),
            child: BalanceActions(
              onReceive: () {
                ref.read(receiveCoinsFormControllerProvider.notifier).setCoin(coinsGroup);
                CoinReceiveRoute().push<void>(context);
              },
              onNeedToEnable2FA: () => SecureAccountModalRoute().push<void>(context),
              onSend: () {
                ref.invalidate(sendAssetFormControllerProvider);
                ref.read(sendAssetFormControllerProvider.notifier).setCoin(coinsGroup);
                SelectNetworkWalletRoute().push<void>(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
