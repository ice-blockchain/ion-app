import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_receive_modal/model/coin_receive_modal_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/balance/balance_actions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class Balance extends HookConsumerWidget {
  const Balance({
    required this.coinData,
    required this.networkType,
    super.key,
  });

  final CoinData coinData;
  final NetworkType networkType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = '${formatToCurrency(coinData.amount, '')} ${coinData.abbreviation}';

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
                    Assets.images.icons.iconArrowSelect.icon(size: 12.0.s),
                  ],
                ),
                Text(
                  '~ ${formatToCurrency(coinData.balance)}',
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
                CoinReceiveRoute(
                  $extra: CoinReceiveModalData(
                    coinData: coinData,
                    networkType: networkType,
                  ),
                ).push<void>(context);
              },
              onSend: () {},
            ),
          ),
        ],
      ),
    );
  }
}
