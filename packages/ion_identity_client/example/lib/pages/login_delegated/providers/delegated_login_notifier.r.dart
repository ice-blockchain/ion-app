// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client_example/providers/ion_identity_provider.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delegated_login_notifier.r.g.dart';

@riverpod
class DelegatedLoginNotifier extends _$DelegatedLoginNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> delegatedLogin({required String username}) async {
    state = const AsyncLoading();

    try {
      final ionIdentity = await ref.read(ionIdentityProvider.future);
      await ionIdentity(username: username).auth.delegatedLogin();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
