// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/protect_account/email/providers/linked_email_provider.c.dart';
import 'package:ion/app/features/protect_account/email/providers/linked_phone_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_twofa_notifier.c.g.dart';

@riverpod
class EditTwoFaCodeNotifier extends _$EditTwoFaCodeNotifier {
  @override
  FutureOr<void> build() => null;

  Future<void> editTwoFa(TwoFAType twoFAType) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final oldValue = await _getTwoFaLinkedValue(twoFAType);
      if (oldValue == null) return;

      final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);
      return ionIdentityClient.auth.verifyTwoFA(twoFAType, oldValue: oldValue);
    });
  }

  Future<String?> _getTwoFaLinkedValue(TwoFAType type) async {
    return switch (type) {
      TwoFAType.email => ref.read(linkedEmailProvider.future),
      TwoFAType.sms => ref.read(linkedPhoneProvider.future),
      _ => null,
    };
  }
}
