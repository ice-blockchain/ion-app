// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

/// Abstract interface for signing user actions with different authentication methods.
///
/// This replaces the complex callback pattern of OnVerifyIdentity with a simple,
/// clean interface that encapsulates the authentication method.
abstract class UserActionSignerNew {
  /// Signs a user action and returns the decoded response.
  ///
  /// The implementation handles the specific authentication flow (passkey, password, or biometrics)
  /// internally without exposing the complexity to the caller.
  Future<T> sign<T>(
    UserActionSigningRequest request,
    T Function(JsonObject) responseDecoder,
  );
}
