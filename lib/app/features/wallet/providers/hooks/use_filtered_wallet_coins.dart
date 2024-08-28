import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/providers/coins_provider.dart';

List<CoinData> useFilteredWalletCoins(WidgetRef ref) {
  final isZeroValueAssetsVisible = isZeroValueAssetsVisibleSelector(ref);

  final walletCoins = ref.watch(
    coinsNotifierProvider.select(
      (AsyncValue<List<CoinData>> data) => data.value ?? <CoinData>[],
    ),
  );

  return useMemoized(
    () {
      return isZeroValueAssetsVisible
          ? walletCoins
          : walletCoins.where((CoinData coin) => coin.balance > 0.00).toList();
    },
    [isZeroValueAssetsVisible, walletCoins],
  );
}
