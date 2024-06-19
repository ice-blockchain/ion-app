import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/providers/selectors/wallet_assets_selectors.dart';

List<CoinData> useFilteredWalletCoins(WidgetRef ref) {
  final isZeroValueAssetsVisible = isZeroValueAssetsVisibleSelector(ref);
  final walletCoins = coinsDataSelector(ref);

  return useMemoized(
    () {
      return isZeroValueAssetsVisible
          ? walletCoins
          : walletCoins.where((CoinData coin) => coin.balance > 0.00).toList();
    },
    <Object?>[isZeroValueAssetsVisible, walletCoins],
  );
}
