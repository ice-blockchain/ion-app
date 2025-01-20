// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<CoinInWalletData>> coinsInWallet(Ref ref) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    return [];
  }
  final walletData = await ref.watch(currentWalletViewDataProvider.future);
  return walletData.coins;
}

@riverpod
Future<CoinInWalletData> coinInWalletById(Ref ref, {required String coinId}) async {
  final coins = await ref.watch(coinsInWalletProvider.future);

  return coins.firstWhere((coin) => coin.coin.id == coinId);
}
