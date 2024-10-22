// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ion/app/services/ion_identity_client/mocked_ton_wallet_keystore.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_wallet_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Wallet?> mainWallet(Ref ref) async {
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
  var tempMainWallet = wallets.firstWhereOrNull((wallet) => wallet.name == 'temp-main');
  tempMainWallet ??= await ionClient(username: currentIdentityKeyName)
      .wallets
      .createWallet(network: 'KeyEdDSA', name: 'temp-main');
  // TODO: still using mocked wallet because damus do not accept non default signatures
  return tempMainWallet.copyWith(
    signingKey: tempMainWallet.signingKey.copyWith(publicKey: mockedTonWalletKeystore.publicKey),
  );
}
