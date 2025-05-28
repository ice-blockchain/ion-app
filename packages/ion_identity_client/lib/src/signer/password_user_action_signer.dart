// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/signer/user_action_signer_new.dart';

/// Implementation of UserActionSignerNew that uses password authentication.
/// The password is obtained lazily when sign() is called, not during construction.
class PasswordUserActionSigner implements UserActionSignerNew {
  const PasswordUserActionSigner({
    required this.userActionSigner,
    required this.getPassword,
  });

  final UserActionSigner userActionSigner;
  final Future<String> Function() getPassword;

  @override
  Future<T> sign<T>(
    UserActionSigningRequest request,
    T Function(JsonObject) responseDecoder,
  ) async {
    final password = await getPassword();
    return userActionSigner.signWithPassword(request, responseDecoder, password);
  }
}
