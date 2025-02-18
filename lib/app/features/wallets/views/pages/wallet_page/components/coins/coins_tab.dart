// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallets/providers/filtered_assets_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/coins_list/coin_item.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/coins/coins_tab_footer.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/loaders/list_loader.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/router/app_routes.c.dart';

class CoinsTab extends ConsumerWidget {
  const CoinsTab({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.coins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCoinsState = ref.watch(filteredCoinsNotifierProvider);

    return selectedCoinsState.maybeWhen(
      data: (groups) {
        if (groups.isEmpty) {
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
              itemCount: groups.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.0.s),
              itemBuilder: (context, index) => ScreenSideOffset.small(
                child: CoinsGroupItem(
                  coinsGroup: groups[index],
                  onTap: () =>
                      CoinsDetailsRoute(symbolGroup: groups[index].symbolGroup).go(context),
                ),
              ),
            ),
            const CoinsTabFooter(),
          ],
        );
      },
      loading: () => const ListLoader(),
      orElse: () => const SliverToBoxAdapter(
        child: SizedBox.shrink(),
      ),
    );
  }
}
