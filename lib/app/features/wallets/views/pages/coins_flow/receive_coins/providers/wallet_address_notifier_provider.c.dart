// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/core/providers/wallets_provider.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart' as ion;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_address_notifier_provider.c.g.dart';

@riverpod
class WalletAddressNotifier extends _$WalletAddressNotifier {
  @override
  FutureOr<void> build() {}

  Future<String?> createWallet({
    required NetworkData network,
    required ion.OnVerifyIdentity<ion.Wallet> onVerifyIdentity,
  }) async {
    state = const AsyncValue.loading();

    String? walletAddress;
    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityClientProvider.future);
      final walletView = await ref.read(currentWalletViewDataProvider.future);

      final result = await ionIdentity.wallets.createWallet(
        network: network.id,
        walletViewId: walletView.id,
        onVerifyIdentity: onVerifyIdentity,
      );

      await ref.read(walletsNotifierProvider.notifier).addWallet(result);

      walletAddress = result.address;
    });

    return walletAddress;
  }

  Future<String?> loadWalletAddress() async {
    final receiveCoinsForm = ref.read(receiveCoinsFormControllerProvider);

    final coin = receiveCoinsForm.selectedCoin?.coins.firstWhereOrNull(
      (coinInWallet) => coinInWallet.coin.network == receiveCoinsForm.selectedNetwork,
    );

    // Get address from CoinInWallet if exists
    var address = coin?.walletAddress;

    // Attempt to get address from existed wallets
    if (address == null && coin?.walletId != null) {
      final wallets = await ref.read(walletsNotifierProvider.future);
      address = wallets.firstWhereOrNull((wallet) => wallet.id == coin?.walletId)?.address;
    }

    return address;
  }
}
