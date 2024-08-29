import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_coins.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/coins/coin_item.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/app/router/app_routes.dart';

class CoinsTab extends HookConsumerWidget {
  const CoinsTab({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.coins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = useFilteredWalletCoins(ref);

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
        // Prevent re-rendering by ensuring only the needed parts are rebuilt
        return ScreenSideOffset.small(
          child: CoinItem(
            coinData: coins[index],
            onTap: () {
              CoinsDetailsRoute(coinId: coins[index].abbreviation).go(context);
            },
          ),
        );
      },
    );
  }
}
