import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/providers/wallet_data_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/coins/coin_item.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';

class CoinsTab extends HookConsumerWidget {
  const CoinsTab({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.coins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CoinData> coins = walletCoinsSelector(ref);

    if (coins.isEmpty) {
      return const EmptyState(
        tabType: tabType,
      );
    }

    return SliverList.separated(
      itemCount: coins.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 12.0.s,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        if (index == coins.length - 1) {
          return ScreenSideOffset.small(
            child: Column(
              children: <Widget>[
                CoinItem(
                  coinData: coins[index],
                ),
                BottomAction(
                  asset: tabType.bottomActionAsset,
                  title: tabType.getBottomActionTitle(context),
                  onTap: () {},
                ),
              ],
            ),
          );
        }
        return ScreenSideOffset.small(
          child: CoinItem(
            coinData: coins[index],
          ),
        );
      },
    );
  }
}
