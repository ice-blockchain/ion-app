// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';

/// Factory for creating appropriate UserActionSignerNew implementations
/// based on user authentication preferences and capabilities.
class UserActionSignerFactory {
  const UserActionSignerFactory({
    required this.userActionSigner,
    required this.ionIdentityAuth,
  });

  final UserActionSigner userActionSigner;
  final IONIdentityAuth ionIdentityAuth;

  /// Creates a UserActionSignerNew based on user preferences and biometrics state.
  ///
  /// Priority:
  /// 1. If user is password flow user and biometrics enabled -> BiometricsUserActionSigner
  /// 2. If user is password flow user and biometrics disabled -> PasswordUserActionSigner (gets password via callback)
  /// 3. If user is passkey user -> PasskeyUserActionSigner
  UserActionSignerNew createSigner({
    String? localisedReasonForBiometrics,
    String? localisedCancelForBiometrics,
    Future<String> Function()? getPassword,
  }) {
    final isPasswordFlowUser = ionIdentityAuth.isPasswordFlowUser();
    final biometricsState = ionIdentityAuth.getBiometricsState();

    if (isPasswordFlowUser) {
      if (biometricsState == BiometricsState.enabled &&
          localisedReasonForBiometrics != null &&
          localisedCancelForBiometrics != null) {
        return createBiometricsSigner(
          localisedReason: localisedReasonForBiometrics,
          localisedCancel: localisedCancelForBiometrics,
        );
      }

      // For password flow users without biometrics
      if (getPassword != null) {
        return createPasswordSignerWithCallback(getPassword: getPassword);
      }

      throw ArgumentError(
          'Password callback is required for password flow users when biometrics is not available');
    } else {
      return createPasskeySigner();
    }
  }

  /// Creates a PasskeyUserActionSigner specifically for passkey authentication.
  UserActionSignerNew createPasskeySigner() {
    return PasskeyUserActionSigner(
      userActionSigner: userActionSigner,
    );
  }

  /// Creates a PasswordUserActionSigner with a callback for lazy password retrieval.
  UserActionSignerNew createPasswordSignerWithCallback({
    required Future<String> Function() getPassword,
  }) {
    return PasswordUserActionSigner(
      userActionSigner: userActionSigner,
      getPassword: getPassword,
    );
  }

  /// Creates a BiometricsUserActionSigner specifically for biometric authentication.
  UserActionSignerNew createBiometricsSigner({
    required String localisedReason,
    required String localisedCancel,
  }) {
    return BiometricsUserActionSigner(
      userActionSigner: userActionSigner,
      localisedReason: localisedReason,
      localisedCancel: localisedCancel,
    );
  }
}
