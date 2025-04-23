// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_action_notifier.c.g.dart';

@riverpod
class RegisterActionNotifier extends _$RegisterActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> signUp({required String keyName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      try {
        await ionIdentity(username: keyName).auth.registerUser();
      } on PasskeyCancelledException {
        return;
      }
    });
  }

  Future<void> signUpWithPassword({required String keyName, required String password}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      try {
        await ionIdentity(username: keyName).auth.registerUserWithPassword(password);
      } on PasskeyCancelledException {
        return;
      }
    });
  }
}
