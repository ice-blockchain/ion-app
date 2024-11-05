// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.dart';
import 'package:ion_identity_client/ion_identity.dart';

Future<void> requestTwoFACode(WidgetRef ref, TwoFAType twoFAType) async {
  final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);
  return ionIdentityClient.auth.requestTwoFACode(twoFAType: twoFAType);
}

Future<void> validateTwoFACode(WidgetRef ref, TwoFAType twoFAType) async {
  final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);
  return ionIdentityClient.auth.verifyTwoFA(twoFAType);
}
