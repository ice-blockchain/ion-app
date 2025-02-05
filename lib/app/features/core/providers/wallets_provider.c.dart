// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_provider.c.g.dart';

@Riverpod(keepAlive: true)
class WalletsNotifier extends _$WalletsNotifier {
  @override
  Future<List<Wallet>> build() async {
    final ionIdentity = await ref.watch(ionIdentityClientProvider.future);
    return ionIdentity.wallets.getWallets();
  }

  Future<void> addWallet(Wallet wallet) async {
    final currentWallets = state.valueOrNull ?? [];

    // Only add if not already present
    if (!currentWallets.any((w) => w.id == wallet.id)) {
      state = AsyncData([...currentWallets, wallet]);
    }
  }
}
