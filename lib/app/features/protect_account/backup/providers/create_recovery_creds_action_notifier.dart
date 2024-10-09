// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_recovery_creds_action_notifier.g.dart';

@riverpod
class CreateRecoveryCredsActionNotifier extends _$CreateRecoveryCredsActionNotifier {
  @override
  FutureOr<CreateRecoveryCredentialsSuccess?> build() {
    return null;
  }

  Future<void> createRecoveryCredentials() async {
    state = const AsyncValue.loading();

    try {
      final selectedUser = ref.read(authProvider).valueOrNull?.selectedIdentityKeyName;
      if (selectedUser == null) {
        throw Exception('No selected user');
      }

      final ionClient = await ref.read(ionApiClientProvider.future);

      final result = await ionClient(username: selectedUser).auth.createRecoveryCredentials();

      state = switch (result) {
        CreateRecoveryCredentialsSuccess() => AsyncValue.data(result),
        CreateRecoveryCredentialsFailure() => AsyncValue.error(result, StackTrace.current),
      };
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
