// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/providers/filtered_assets_provider.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.dart';

typedef FilteredCoinsResult = ({List<CoinData> coins, bool isLoading});

FilteredCoinsResult useFilteredWalletCoins(WidgetRef ref) {
  final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);

  final coinsState = ref.watch(filteredCoinsProvider);

  final walletCoins = coinsState.valueOrNull ?? <CoinData>[];
  final isLoading = coinsState.isLoading;

  final filteredCoins = useMemoized(
    () {
      return isZeroValueAssetsVisible
          ? walletCoins
          : walletCoins.where((CoinData coin) => coin.balance > 0.00).toList();
    },
    [isZeroValueAssetsVisible, walletCoins],
  );

  return (coins: filteredCoins, isLoading: isLoading);
}
