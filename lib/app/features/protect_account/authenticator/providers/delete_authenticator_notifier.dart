// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_identity/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_authenticator_notifier.g.dart';

@riverpod
class DeleteAuthenticatorNotifier extends _$DeleteAuthenticatorNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> deleteAuthenticator(
    TwoFAType twoFAType,
    List<TwoFAType> verificationCodes,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final client = await ref.read(ionIdentityClientProvider.future);
      await client.auth.deleteTwoFA(twoFAType, verificationCodes);
    });
  }
}
