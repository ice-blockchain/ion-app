// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client_example/providers/ion_identity_client_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_key_notifier.c.g.dart';

@riverpod
class CreateKeyNotifier extends _$CreateKeyNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> createKey() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);
      await ionIdentityClient.keys.createKey(
        scheme: 'DH',
        curve: 'secp256k1',
        name: 'device',
        onVerifyIdentity: ({
          required onBiometricsFlow,
          required onPasskeyFlow,
          required onPasswordFlow,
        }) =>
            onPasskeyFlow(),
      );
    });
  }
}
