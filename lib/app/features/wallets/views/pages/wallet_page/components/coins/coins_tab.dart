// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallets/providers/filtered_assets_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/coins_list/coin_item.dart';
import 'package:ion/app/features/wallets/views/pages/manage_coins/providers/manage_coins_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/coins/coins_tab_footer.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/tab_type.dart';
import 'package:ion/app/router/app_routes.c.dart';

class CoinsTab extends ConsumerWidget {
  const CoinsTab({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.coins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(filteredCoinsNotifierProvider.select((state) => state.value));

    if (groups == null || groups.isEmpty) {
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
          itemBuilder: (context, index) {
            final group = groups[index];

            final isUpdating = ref.watch(
              manageCoinsNotifierProvider.select(
                (state) => state.valueOrNull?[group.symbolGroup]?.isUpdating ?? false,
              ),
            );

            return ScreenSideOffset.small(
              child: isUpdating
                  ? const CoinsGroupItemPlaceholder()
                  : CoinsGroupItem(
                      coinsGroup: group,
                      onTap: () => CoinsDetailsRoute(symbolGroup: group.symbolGroup).go(context),
                    ),
            );
          },
        ),
        const CoinsTabFooter(),
      ],
    );
  }
}
