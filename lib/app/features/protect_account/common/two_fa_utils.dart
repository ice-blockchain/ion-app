// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/protect_account/secure_account/providers/two_fa_signature_wrapper_notifier.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

Future<String?> requestTwoFACode(
  WidgetRef ref,
  TwoFAType twoFAType,
) async {
  final ionIdentityClient = await ref.read(ionIdentityClientProvider.future);
  final twoFaWrapper = ref.read(twoFaSignatureWrapperNotifierProvider.notifier);
  String? code;
  await twoFaWrapper.wrapWithSignature((signature) async {
    code = await ionIdentityClient.auth.requestTwoFACode(
      twoFAType: twoFAType,
      signature: signature,
    );
  });
  return code;
}
