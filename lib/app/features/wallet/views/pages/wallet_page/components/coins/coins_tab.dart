// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallet/components/coins_list/coin_item.dart';
import 'package:ion/app/features/wallet/providers/filtered_wallet_coins_provider.c.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/coins/coins_tab_footer.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/router/app_routes.c.dart';

class CoinsTab extends ConsumerWidget {
  const CoinsTab({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.coins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCoinsState = ref.watch(filteredWalletCoinsProvider);

    return selectedCoinsState.maybeWhen(
      data: (selectedCoins) {
        if (selectedCoins.isEmpty) {
          return EmptyState(
            tabType: tabType,
            onBottomActionTap: () {
              ManageCoinsRoute().go(context);
            },
          );
        }

        return SliverMainAxisGroup(
          slivers: [
            SliverList.separated(
              itemCount: selectedCoins.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 12.0.s);
              },
              itemBuilder: (BuildContext context, int index) {
                return ScreenSideOffset.small(
                  child: CoinItem(
                    coinData: selectedCoins[index],
                    onTap: () {
                      CoinsDetailsRoute(coinId: selectedCoins[index].abbreviation).go(context);
                    },
                  ),
                );
              },
            ),
            const CoinsTabFooter(),
          ],
        );
      },
      orElse: () => const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      ),
    );
  }
}
