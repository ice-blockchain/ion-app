// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connected_crypto_wallets_provider.c.g.dart';

/// Returns all connected crypto wallets to the WalletView.
@riverpod
Future<List<Wallet>> connectedCryptoWallets(Ref ref) async {
  final walletViews = await ref.watch(walletViewsDataNotifierProvider.future);
  final cryptoWallets = await ref.watch(walletsNotifierProvider.future);

  final walletIds =
      walletViews.expand((view) => view.coins).map((coin) => coin.walletId).nonNulls.toList();

  return cryptoWallets.filterByIds(walletIds);
}

/// Returns crypto wallets of the current WalletView.
@riverpod
Future<List<Wallet>> currentWalletViewCryptoWallets(Ref ref) async {
  final walletView = await ref.watch(currentWalletViewDataProvider.future);
  final cryptoWallets = await ref.watch(walletsNotifierProvider.future);

  final walletIds = walletView.coins.map((coin) => coin.walletId).nonNulls.toList();

  return cryptoWallets.filterByIds(walletIds);
}

/// Returns crypto wallets of the main WalletView.
@riverpod
Future<List<Wallet>> mainCryptoWallets(Ref ref) async {
  final walletViews = await ref.watch(walletViewsDataNotifierProvider.future);
  final cryptoWallets = await ref.watch(walletsNotifierProvider.future);

  final walletIds = walletViews
      .firstWhere((w) => w.isMainWalletView)
      .coins
      .map((coin) => coin.walletId)
      .nonNulls
      .toList();

  return cryptoWallets.filterByIds(walletIds);
}

extension on List<Wallet> {
  List<Wallet> filterByIds(List<String> ids) {
    return where((cryptoWallet) => ids.contains(cryptoWallet.id)).toList();
  }
}
