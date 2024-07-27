import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/providers/coins_provider.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_coins.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/coins/coin_item.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/app_routes.dart';

class CoinsTab extends HookConsumerWidget {
  const CoinsTab({
    super.key,
  });

  static const WalletTabType tabType = WalletTabType.coins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = useFilteredWalletCoins(ref);
    final searchValue = walletAssetSearchValueSelector(ref, tabType);
    final walletId = ref.watch(walletRepositoryProvider).currentWalletId;

    useOnInit<void>(
      () {
        if (walletId.isNotEmpty) {
          ref
              .read(coinsNotifierProvider.notifier)
              .fetch(searchValue: searchValue, walletId: walletId);
        }
      },
      <Object?>[searchValue, walletId],
    );

    if (coins.isEmpty) {
      return const SliverToBoxAdapter(
        child: SizedBox.shrink(),
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
              CoinsDetailsRoute($extra: coins[index]).go(context);
            },
          ),
        );
      },
    );
  }
}
