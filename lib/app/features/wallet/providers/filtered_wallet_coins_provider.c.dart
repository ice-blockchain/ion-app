// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/providers/manage_coins_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_wallet_coins_provider.c.g.dart';

@riverpod
Future<List<CoinInWalletData>> filteredWalletCoins(Ref ref) async {
  final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);

  //TODO: Connect filteredCoinsProvider when API is ready
  final selectedCoinsState = ref.watch(selectedCoinsProvider);

  return selectedCoinsState.maybeWhen(
    data: (selectedCoins) {
      final walletCoins = selectedCoins.map((coin) => coin.coinInWallet).toList();

      return isZeroValueAssetsVisible
          ? walletCoins
          : walletCoins.where((coin) => coin.balanceUSD > 0.00).toList();
    },
    orElse: () => [],
  );
}
