// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recover_user_action_notifier.g.dart';

@riverpod
class RecoverUserActionNotifier extends _$RecoverUserActionNotifier {
  @override
  FutureOr<RecoverUserSuccess?> build() => null;

  Future<void> recoverUser({
    required String username,
    required String credentialId,
    required String recoveryKey,
  }) async {
    state = const AsyncLoading();

    try {
      final ionClient = await ref.read(ionApiClientProvider.future);

      final result = await ionClient(username: username)
          .auth
          .recoverUser(credentialId: credentialId, recoveryKey: recoveryKey);

      state = switch (result) {
        RecoverUserSuccess() => AsyncValue.data(result),
        RecoverUserFailure() => AsyncValue.error(result, StackTrace.current),
      };
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
