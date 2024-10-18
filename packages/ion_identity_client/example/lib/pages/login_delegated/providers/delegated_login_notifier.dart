// SPDX-License-Identifier: ice License 1.0

import 'package:ion_client_example/providers/ion_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delegated_login_notifier.g.dart';

@riverpod
class DelegatedLoginNotifier extends _$DelegatedLoginNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> delegatedLogin({required String username}) async {
    state = const AsyncLoading();

    try {
      final ionClient = await ref.read(ionClientProvider.future);
      await ionClient(username: username).auth.delegatedLogin();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
