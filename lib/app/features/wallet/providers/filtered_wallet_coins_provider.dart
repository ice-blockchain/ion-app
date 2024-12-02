// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/coin_data.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/providers/manage_coins_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_wallet_coins_provider.g.dart';

@riverpod
Future<List<CoinData>> filteredWalletCoins(Ref ref) async {
  final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);

  //TODO: Connect filteredCoinsProvider when API is ready
  final selectedCoinsState = ref.watch(selectedCoinsProvider);

  return selectedCoinsState.maybeWhen(
    data: (selectedCoins) {
      final walletCoins = selectedCoins.map((coin) => coin.coinData).toList();

      return isZeroValueAssetsVisible
          ? walletCoins
          : walletCoins.where((CoinData coin) => coin.balance > 0.00).toList();
    },
    orElse: () => <CoinData>[],
  );
}
