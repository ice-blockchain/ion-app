// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/protect_account/authenticator/data/adapter/twofa_type_adapter.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/user_details_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_provider.c.dart';
import 'package:ion/app/utils/predicates.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_twofa_code_notifier.c.g.dart';

@riverpod
class RequestTwoFaCodeNotifier extends _$RequestTwoFaCodeNotifier {
  @override
  FutureOr<String?> build() => null;

  Future<void> requestTwoFaCode(
    TwoFaType twoFaType,
    OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  ) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final client = await ref.read(ionIdentityClientProvider.future);
      final twoFAType = await _getTwoFAType(twoFaType);

      return client.auth.requestTwoFACode(twoFAType: twoFAType, onVerifyIdentity: onVerifyIdentity);
    });
  }

  Future<void> requestRecoveryTwoFaCode(
    TwoFaType twoFaType,
    String recoveryIdentityKeyName,
    OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
  ) async {
    if (state.isLoading) {
      return;
    }

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final client = await ref.read(ionIdentityProvider.future);
      final twoFAType = TwoFaTypeAdapter(twoFaType).twoFAType;

      return client(username: '').auth.requestTwoFACode(
            twoFAType: twoFAType,
            recoveryIdentityKeyName: recoveryIdentityKeyName,
            onVerifyIdentity: onVerifyIdentity,
          );
    });
  }

  Future<TwoFAType> _getTwoFAType(TwoFaType twoFaType) async {
    if (twoFaType == TwoFaType.auth) {
      return const TwoFAType.authenticator();
    }

    final userDetails = await ref.read(userDetailsProvider.future);

    final twoFAOptionsFilter = switch (twoFaType) {
      TwoFaType.email => startsWith(const TwoFAType.email().option),
      TwoFaType.sms => startsWith(const TwoFAType.sms().option),
      TwoFaType.auth => (v) => true,
    };

    final twoFAOptions = userDetails.twoFaOptions?.where(twoFAOptionsFilter).toList() ?? [];

    final userContacts = switch (twoFaType) {
          TwoFaType.email => userDetails.email,
          TwoFaType.sms => userDetails.phoneNumber,
          TwoFaType.auth => null,
        } ??
        [];

    final contactsIndex = int.tryParse(twoFAOptions.firstOrNull?.split(':').last ?? '0') ?? 0;

    return TwoFaTypeAdapter(twoFaType, userContacts[contactsIndex]).twoFAType;
  }
}
