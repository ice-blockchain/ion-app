// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_wallet_notifier.g.dart';

@riverpod
class CreateWalletNotifier extends _$CreateWalletNotifier {
  @override
  FutureOr<Wallet?> build() {
    return null;
  }

  Future<void> createWallet() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () async {
        final username = ref.read(currentUsernameNotifierProvider) ?? 'ERROR';
        final ionIdentity = await ref.read(ionIdentityProvider.future);
        return ionIdentity(username: username)
            .wallets
            .createWallet(network: 'KeyEdDSA', name: 'KeyEdDSA ${Random().nextInt(1000000)}');
      },
    );
  }
}
