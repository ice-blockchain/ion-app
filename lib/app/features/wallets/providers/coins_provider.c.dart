// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
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

@riverpod
Future<CoinInWalletData?> coinInWalletById(Ref ref, {required String coinId}) async {
  // TODO (1) Recheck this provider. Looks like nullability here is extra.
  final coinGroups = await ref.watch(coinsInWalletProvider.future);
  for (final group in coinGroups) {
    for (final coin in group.coins) {
      if (coin.coin.id == coinId) {
        return coin;
      }
    }
  }
  return null;
}
