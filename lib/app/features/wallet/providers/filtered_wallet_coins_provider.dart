// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/coin_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_wallet_coins_provider.g.dart';

@riverpod
Future<List<CoinData>> filteredWalletCoins(Ref ref) async {
  final isZeroValueAssetsVisible = ref.watch(isZeroValueAssetsVisibleSelectorProvider);
  final coinsState = ref.watch(filteredCoinsProvider);

  final walletCoins = coinsState.valueOrNull ?? <CoinData>[];

  return isZeroValueAssetsVisible
      ? walletCoins
      : walletCoins.where((CoinData coin) => coin.balance > 0.00).toList();
}
