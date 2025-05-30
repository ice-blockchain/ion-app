// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/signer/user_action_signer_new.dart';

/// Implementation of UserActionSignerNew that uses biometric authentication.
class BiometricsUserActionSigner implements UserActionSignerNew {
  const BiometricsUserActionSigner({
    required this.userActionSigner,
    required this.localisedReason,
    required this.localisedCancel,
  });

  final UserActionSigner userActionSigner;
  final String localisedReason;
  final String localisedCancel;

  @override
  Future<T> sign<T>(
    UserActionSigningRequest request,
    T Function(JsonObject) responseDecoder,
  ) async {
    return userActionSigner.signWithBiometrics(
      request,
      responseDecoder,
      localisedReason,
      localisedCancel,
    );
  }
}
