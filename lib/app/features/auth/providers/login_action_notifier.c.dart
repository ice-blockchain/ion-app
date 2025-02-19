// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/authenticator/data/adapter/twofa_type_adapter.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_action_notifier.c.g.dart';

@riverpod
class LoginActionNotifier extends _$LoginActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> verifyUserLoginFlow({required String keyName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      await ionIdentity(username: keyName).auth.verifyUserLoginFlow();
    });
  }

  Future<void> signIn({
    required String keyName,
    required OnVerifyIdentity<AssertionRequestData> onVerifyIdentity,
    required bool localCredsOnly,
    Map<TwoFaType, String>? twoFaTypes,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      final twoFATypes = [
        for (final entry in (twoFaTypes ?? {}).entries)
          TwoFaTypeAdapter(entry.key, entry.value).twoFAType,
      ];

      await ionIdentity(username: keyName).auth.loginUser(
            onVerifyIdentity: onVerifyIdentity,
            twoFATypes: twoFATypes,
            localCredsOnly: localCredsOnly,
          );
    });
  }
}
