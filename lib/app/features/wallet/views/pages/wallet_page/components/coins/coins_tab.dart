// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallet/components/coins_list/coin_item.dart';
import 'package:ion/app/features/wallet/providers/filtered_wallet_coins_provider.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/router/app_routes.dart';

class CoinsTab extends ConsumerWidget {
  const CoinsTab({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.coins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(filteredWalletCoinsProvider).valueOrNull ?? [];

    // TODO: add proper loading state
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
