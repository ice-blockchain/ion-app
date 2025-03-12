// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connected_crypto_wallets_provider.c.g.dart';

@riverpod
Future<List<Wallet>> connectedCryptoWallets(Ref ref) async {
  final walletsFromWalletViews = await ref.read(walletViewsDataNotifierProvider.future);
  final cryptoWallets = await ref.read(walletsNotifierProvider.future);

  final walletIds = walletsFromWalletViews
      .expand((view) => view.coinGroups)
      .expand((group) => group.coins)
      .map((coin) => coin.walletId)
      .nonNulls
      .toList();

  return cryptoWallets.where((cryptoWallet) => walletIds.contains(cryptoWallet.id)).toList();
}
