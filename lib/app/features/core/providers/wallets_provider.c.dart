// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallets_provider.c.g.dart';

@riverpod
class WalletsNotifier extends _$WalletsNotifier {
  @override
  Future<List<Wallet>> build() async {
    keepAliveWhenAuthenticated(ref);

    try {
      final ionIdentity = await ref.watch(ionIdentityClientProvider.future);
      return await ionIdentity.wallets.getWallets();
    } on NetworkException {
      throw WalletsLoadingException();
    }
  }

  Future<void> addWallet(Wallet wallet) async {
    final currentWallets = state.valueOrNull ?? [];

    // Only add if not already present
    if (!currentWallets.any((w) => w.id == wallet.id)) {
      state = AsyncData([...currentWallets, wallet]);
    }
  }
}
