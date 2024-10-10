// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_action_notifier.g.dart';

@riverpod
class RegisterActionNotifier extends _$RegisterActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> signUp({required String keyName}) async {
    state = const AsyncValue.loading();

    try {
      final ionClient = await ref.read(ionClientProvider.future);
      final registerResult = await ionClient(username: keyName).auth.registerUser();

      state = switch (registerResult) {
        RegisterUserSuccess() => const AsyncValue.data(null),
        RegisterUserFailure() => AsyncValue.error(registerResult, StackTrace.current),
      };
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
