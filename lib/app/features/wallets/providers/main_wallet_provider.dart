// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_wallet_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Wallet?> mainWallet(MainWalletRef ref) async {
  final currentIdentityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
  if (currentIdentityKeyName == null) {
    return null;
  }
  // TODO: take the list from walletsDataNotifierProvider when connected to ionClient
  final ionClient = await ref.watch(ionApiClientProvider.future);
  final wallets = await ionClient(username: currentIdentityKeyName).wallets.getWallets();
  final mainWallet = wallets.firstWhereOrNull((wallet) => wallet.name == 'main');
  if (mainWallet == null) {
    throw Exception('Main wallet is not found');
  }

  // TODO:take `mainWallet` when signing with TON is implemented and remove this 'temp-main'
  final tempMainWallet = wallets.firstWhereOrNull((wallet) => wallet.name == 'temp-main');
  return tempMainWallet ??
      await ionClient(username: currentIdentityKeyName)
          .wallets
          .createWallet(network: 'KeyEdDSA', name: 'temp-main');
}
