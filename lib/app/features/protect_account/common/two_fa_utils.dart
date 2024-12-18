// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

Future<String?> requestTwoFACode(
  WidgetRef ref,
  TwoFAType twoFAType,
  OnVerifyIdentity<GenerateSignatureResponse> onVerifyIdentity,
) async {
  final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);
  return ionIdentityClient.auth
      .requestTwoFACode(twoFAType: twoFAType, onVerifyIdentity: onVerifyIdentity);
}

Future<void> validateTwoFACode(WidgetRef ref, TwoFAType twoFAType) async {
  final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);
  return ionIdentityClient.auth.verifyTwoFA(twoFAType);
}
