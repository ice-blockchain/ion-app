// SPDX-License-Identifier: ice License 1.0

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_action_notifier.g.dart';

@riverpod
class LoginActionNotifier extends _$LoginActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String keyName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionClient = await ref.read(ionApiClientProvider.future);
      await ionClient(username: keyName).auth.loginUser();
    });
  }
}
