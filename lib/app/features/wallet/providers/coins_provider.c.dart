// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/wallet/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallets_data_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coins_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<CoinData>> coinsData(Ref ref) async {
  final currentUser = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentUser == null) {
    return [];
  }
  final currentWalletId = await ref.watch(currentWalletIdProvider.future);

  final ionIdentity = await ref.watch(ionIdentityProvider.future);
  final walletAssets =
      await ionIdentity(username: currentUser).wallets.getWalletAssets(currentWalletId);

  final coins = [
    for (final (_, asset) in walletAssets.assets.indexed)
      // TODO: get actual coins data
      CoinData(
        abbreviation: asset.symbol,
        name: asset.name ?? 'NULL',
        amount: double.parse(asset.balance) / asset.decimals,
        balance: 0,
        iconUrl: Assets.images.notifications.avatar1,
        asset: 'NULL',
        network: 'NULL',
      ),
  ];

  return coins;
}

@riverpod
Future<CoinData> coinById(Ref ref, {required String coinId}) async {
  final coins = await ref.watch(coinsDataProvider.future);

  return coins.firstWhere((coin) => coin.abbreviation == coinId);
}
