import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_coins.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/bottom_action/bottom_action.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/empty_state/empty_state.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/app/router/my_app_routes.dart';

class CoinsTabFooter extends HookConsumerWidget {
  const CoinsTabFooter({
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
    return SliverToBoxAdapter(
      child: ScreenSideOffset.small(
        child: BottomAction(
          asset: tabType.bottomActionAsset,
          title: tabType.getBottomActionTitle(context),
          onTap: () {
            // IceRoutes.manageCoins.go(
            //   context,
            // );
            const ManageCoinsRoute().go(context);
          },
        ),
      ),
    );
  }
}
