// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/protect_account/secure_account/providers/two_fa_signature_wrapper_notifier.c.dart';
import 'package:ion/app/services/providers/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'delete_twofa_notifier.c.g.dart';

@riverpod
class DeleteTwoFANotifier extends _$DeleteTwoFANotifier {
  @override
  FutureOr<void> build() {}

  Future<void> deleteTwoFa(
    TwoFAType twoFAType,
    List<TwoFAType> verificationCodes,
  ) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final client = await ref.read(ionIdentityClientProvider.future);
      final twoFaWrapper = ref.read(twoFaSignatureWrapperNotifierProvider.notifier);
      await twoFaWrapper.wrapWithSignature(
        (signature) => client.auth.deleteTwoFA(
          twoFAType: twoFAType,
          signature: signature,
          verificationCodes: verificationCodes,
        ),
      );
    });
  }
}
