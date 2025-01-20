// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_wallet_coins_provider.c.g.dart';

@riverpod
Future<List<CoinInWalletData>> filteredWalletCoins(Ref ref) async {
  final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);

  final selectedCoinsState = ref.watch(currentWalletViewDataProvider);

  return selectedCoinsState.maybeWhen(
    data: (walletView) {
      final coins = walletView.coins;
      return isZeroValueAssetsVisible
          ? coins
          : coins.where((coin) => coin.balanceUSD > 0.00).toList();
    },
    orElse: () => [],
  );
}
