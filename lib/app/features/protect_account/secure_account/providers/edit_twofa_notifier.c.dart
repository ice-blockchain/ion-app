// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/providers/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_twofa_notifier.c.g.dart';

@riverpod
class EditTwoFaCodeNotifier extends _$EditTwoFaCodeNotifier {
  @override
  Future<void> build() async {}

  Future<void> editTwoFa(TwoFAType twoFAType) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);
      return ionIdentityClient.auth.verifyTwoFA(twoFAType);
    });
  }
}
