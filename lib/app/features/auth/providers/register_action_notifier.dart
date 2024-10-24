// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/ion_identity_client/ion_identity_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_action_notifier.g.dart';

@riverpod
class RegisterActionNotifier extends _$RegisterActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> signUp({required String keyName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionClient = await ref.read(ionApiClientProvider.future);
      await ionClient(username: keyName).auth.registerUser();
    });
  }
}
