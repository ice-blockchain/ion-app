// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_action_notifier.r.g.dart';

@riverpod
class RegisterActionNotifier extends _$RegisterActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> signUp({required String keyName, String? password}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      if (password != null && password.isNotEmpty) {
        await ionIdentity(username: keyName).auth.registerUserWithPassword(password);
      } else {
        await ionIdentity(username: keyName).auth.registerUser();
      }
    });
  }
}
