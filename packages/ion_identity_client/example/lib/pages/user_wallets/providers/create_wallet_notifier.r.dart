// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client_example/providers/current_username_notifier.r.dart';
import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_wallet_notifier.r.g.dart';

@riverpod
class CreateWalletNotifier extends _$CreateWalletNotifier {
  @override
  FutureOr<Wallet?> build() {
    return null;
  }

  Future<void> createWallet(String network) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () async {
        final username = ref.read(currentUsernameNotifierProvider) ?? 'ERROR';
        final ionIdentity = await ref.read(ionIdentityProvider.future);
        return ionIdentity(username: username).wallets.createWallet(
              network: network,
              name: '$network ${Random().nextInt(1000000)}',
              onVerifyIdentity: (
                      {required onBiometricsFlow,
                      required onPasskeyFlow,
                      required onPasswordFlow}) =>
                  onPasskeyFlow(),
            );
      },
    );
  }
}
