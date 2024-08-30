import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/providers/filtered_assets_provider.dart';

class FilteredCoinsResult {
  final List<CoinData> coins;
  final bool isLoading;

  FilteredCoinsResult({
    required this.coins,
    required this.isLoading,
  });
}

FilteredCoinsResult useFilteredWalletCoins(WidgetRef ref) {
  final isZeroValueAssetsVisible = isZeroValueAssetsVisibleSelector(ref);

  final AsyncValue<List<CoinData>> coinsState = ref.watch(filteredCoinsProvider);

  final walletCoins = coinsState.value ?? <CoinData>[];
  final isLoading = coinsState.isLoading;

  final filteredCoins = useMemoized(
    () {
      return isZeroValueAssetsVisible
          ? walletCoins
          : walletCoins.where((CoinData coin) => coin.balance > 0.00).toList();
    },
    [isZeroValueAssetsVisible, walletCoins],
  );

  return FilteredCoinsResult(coins: filteredCoins, isLoading: isLoading);
}
