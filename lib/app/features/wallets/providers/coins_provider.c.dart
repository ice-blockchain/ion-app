// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/domain/coins/coins_service.c.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<CoinsGroup>> coinsInWallet(Ref ref) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    return [];
  }
  final walletData = await ref.watch(currentWalletViewDataProvider.future);
  return walletData.coinGroups;
}

@Riverpod(keepAlive: true)
Future<List<CoinsGroup>> coinsInWalletView(Ref ref, String walletViewId) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    return [];
  }
  final walletData = await ref.watch(walletViewByIdProvider(id: walletViewId).future);
  return walletData.coinGroups;
}

@Riverpod(keepAlive: true)
Future<CoinData?> coinById(Ref ref, String coinId) async {
  final coinsService = await ref.watch(coinsServiceProvider.future);
  return coinsService.getCoinById(coinId);
}

@riverpod
Future<CoinInWalletData?> coinInWallet(
  Ref ref, {
  required String abbreviation,
  required String symbolGroup,
  required String networkId,
}) async {
  final coinGroups = await ref.watch(coinsInWalletProvider.future);

  for (final group in coinGroups) {
    for (final coin in group.coins) {
      final coinData = coin.coin;
      if (coinData.abbreviation == abbreviation &&
          coinData.symbolGroup == symbolGroup &&
          coinData.network.id == networkId) {
        return coin;
      }
    }
  }
  return null;
}
