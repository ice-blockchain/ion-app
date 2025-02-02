// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/wallets/wallets_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_address_loader_notifier_provider.c.g.dart';

@riverpod
class WalletAddressLoaderNotifier extends _$WalletAddressLoaderNotifier {
  @override
  FutureOr<void> build() {}

  Future<Wallet?> createWallet({
    required Network network,
    required OnVerifyIdentity<Wallet> onVerifyIdentity,
  }) async {
    state = const AsyncValue.loading();

    Wallet? result;
    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityClientProvider.future);
      final walletView = await ref.read(currentWalletViewDataProvider.future);

      result = await ionIdentity.wallets.createWallet(
        network: network.serverName,
        walletViewId: walletView.id,
        onVerifyIdentity: onVerifyIdentity,
      );
    });
    return result;
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
      final wallets = await ref.read(walletsProvider.future);
      address = wallets.firstWhereOrNull((wallet) => wallet.id == coin?.walletId)?.address;
    }

    return address;
  }
}
