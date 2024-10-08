// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_action_notifier.g.dart';

@riverpod
class LoginActionNotifier extends _$LoginActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String keyName}) async {
    state = const AsyncValue.loading();

    try {
      final ionClient = await ref.read(ionApiClientProvider.future);
      final loginResult = await ionClient(username: keyName).auth.loginUser();

      state = switch (loginResult) {
        LoginUserSuccess() => const AsyncValue.data(null),
        LoginUserFailure() => AsyncValue.error(loginResult, StackTrace.current),
      };
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
