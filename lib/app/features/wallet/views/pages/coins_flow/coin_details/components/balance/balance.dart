// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class Balance extends ConsumerWidget {
  const Balance({
    required this.coinData,
    required this.networkType,
    super.key,
  });

  final CoinInWalletData coinData;
  final NetworkType networkType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = '${formatDouble(coinData.amount)} ${coinData.coin.abbreviation}';

    return ScreenSideOffset.small(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.0.s),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: context.theme.appTextThemes.headline1.copyWith(
                        color: context.theme.appColors.primaryText,
                      ),
                    ),
                    SizedBox(
                      width: 4.0.s,
                    ),
                    Assets.svg.iconArrowSelect.icon(size: 12.0.s),
                  ],
                ),
                Text(
                  '~ ${formatToCurrency(coinData.balanceUSD)}',
                  style: context.theme.appTextThemes.subtitle2.copyWith(
                    color: context.theme.appColors.onTertararyBackground,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0.s, top: 11.0.s),
            child: BalanceActions(
              onReceive: () {
                ref.read(receiveCoinsFormControllerProvider.notifier)
                  ..setCoin(coinData)
                  ..setNetwork(networkType);

                CoinReceiveRoute().push<void>(context);
              },
              onSend: () {
                ref.read(sendAssetFormControllerProvider().notifier).setCoin(coinData);
                NetworkSelectSendRoute().push<void>(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
