// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_action_notifier.g.dart';

@riverpod
class LoginActionNotifier extends _$LoginActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String keyName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionClient = await ref.read(ionClientProvider.future);
      await ionClient(username: keyName).auth.loginUser();
    });
  }
}
