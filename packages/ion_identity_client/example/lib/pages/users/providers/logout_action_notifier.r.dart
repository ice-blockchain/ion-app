// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout_action_notifier.r.g.dart';

@riverpod
class LogoutActionNotifier extends _$LogoutActionNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> logOut({required String keyName}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      await ionIdentity(username: keyName).auth.logOut();
    });
  }
}
