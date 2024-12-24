// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_action_notifier.c.g.dart';

@riverpod
class LoginActionNotifier extends _$LoginActionNotifier {
  @override
  FutureOr<({bool? localCredsUsed})> build() => (localCredsUsed: null);

  Future<void> signIn({required String keyName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      try {
        await ionIdentity(username: keyName)
            .auth
            .loginUser(preferImmediatelyAvailableCredentials: true);
        return (localCredsUsed: true);
      } on PasskeyValidationException {
        // No local passkey available, try with another device
        await ionIdentity(username: keyName).auth.loginUser();
        return (localCredsUsed: false);
      }
    });
  }
}
