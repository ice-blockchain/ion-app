// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class Balance extends ConsumerWidget {
  const Balance({
    required this.coinsGroup,
    required this.network,
    super.key,
  });

  final CoinsGroup coinsGroup;
  final NetworkData network;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = '${formatDouble(coinsGroup.totalAmount)} ${coinsGroup.abbreviation}';

    return ScreenSideOffset.small(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(top: 16.0.s),
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
                  '~ ${formatToCurrency(coinsGroup.totalBalanceUSD)}',
                  style: context.theme.appTextThemes.subtitle2.copyWith(
                    color: context.theme.appColors.onTertararyBackground,
                  ),
                ),
              ],
            ),
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
