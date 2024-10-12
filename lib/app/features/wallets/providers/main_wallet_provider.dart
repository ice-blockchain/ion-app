// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ice/app/services/ion_identity_client/mocked_ton_wallet_keystore.dart';
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
  final ionClient = await ref.read(ionApiClientProvider.future);
  final listWalletResult = await ionClient(username: currentIdentityKeyName).wallets.listWallets();
  if (listWalletResult is ListWalletsSuccess) {
    final mainWallet = listWalletResult.wallets.firstWhereOrNull((wallet) => wallet.name == 'main');
    if (mainWallet == null) {
      throw Exception('Main wallet is not found');
    }
    //TODO::return `mainWallet` as is when remote signing with identity is implemented
    // currently replace mainWallet's pubkey with a mocked one to be able to sign on behalf of this wallet
    return Wallet(
      id: mainWallet.id,
      network: mainWallet.network,
      address: mainWallet.address,
      name: mainWallet.name,
      signingKey: WalletSigningKey(
        scheme: mainWallet.signingKey.scheme,
        curve: mainWallet.signingKey.curve,
        publicKey: mockedTonWalletKeystore.publicKey,
      ),
    );
  } else {
    throw Exception(listWalletResult.toString());
  }
}
