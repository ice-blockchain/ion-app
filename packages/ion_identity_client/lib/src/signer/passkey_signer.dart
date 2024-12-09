// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_assertion.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_assertion_data.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_challenge.c.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';

/// The default timeout value (in milliseconds) for operations within the
/// passkey signing process.
const int defaultWaitTimeout = 60000;

/// A configuration class for passkey-related operations, providing options
/// such as timeout settings.
class PasskeysOptions {
  /// Creates an instance of [PasskeysOptions] with the specified [timeout].
  /// If no timeout is provided, it defaults to [defaultWaitTimeout].
  const PasskeysOptions({
    this.timeout = defaultWaitTimeout,
  });

  /// The timeout value (in milliseconds) for passkey operations.
  final int timeout;
}

/// A class responsible for handling passkey-based registration and signing
/// operations. It uses the provided [PasskeysOptions] to configure behavior,
/// such as operation timeouts.
class PasskeysSigner {
  /// Creates an instance of [PasskeysSigner] with the specified [options].
  /// If no options are provided, the default [PasskeysOptions] are used.
  PasskeysSigner([
    this.options = const PasskeysOptions(),
  ]);

  /// The configuration options for passkey operations.
  PasskeysOptions options;

  /// Registers a user based on the provided [challenge], returning a
  /// [CredentialRequestData] containing the attestation data.
  ///
  /// The registration process involves interacting with a passkey authenticator
  /// and relies on the options specified in [PasskeysOptions].
  Future<CredentialRequestData> register(UserRegistrationChallenge challenge) async {
    final registerResponse = await PasskeyAuthenticator().register(
      RegisterRequestType(
        challenge: challenge.challenge,
        relyingParty: RelyingPartyType(
          name: challenge.rp.name,
          id: challenge.rp.id,
        ),
        user: UserType(
          displayName: challenge.user.displayName,
          name: challenge.user.name,
          id: base64UrlEncode(utf8.encode(challenge.user.id)),
        ),
        authSelectionType: AuthenticatorSelectionType(
          authenticatorAttachment:
              challenge.authenticatorSelection.authenticatorAttachment ?? 'platform',
          requireResidentKey: challenge.authenticatorSelection.requireResidentKey,
          residentKey: challenge.authenticatorSelection.residentKey,
          userVerification: challenge.authenticatorSelection.userVerification,
        ),
        pubKeyCredParams: List<PubKeyCredParamType>.from(
          challenge.pubKeyCredParams.map(
            (e) => PubKeyCredParamType(
              type: e.type,
              alg: e.alg,
            ),
          ),
        ),
        timeout: options.timeout,
        attestation: challenge.attestation,
        excludeCredentials: List<CredentialType>.from(
          challenge.excludeCredentials.map(
            (e) => CredentialType(
              type: e.type,
              id: e.id,
              transports: [],
            ),
          ),
        ),
      ),
    );

    return CredentialRequestData(
      credentialInfo: CredentialInfo(
        attestationData: registerResponse.attestationObject,
        clientData: registerResponse.clientDataJSON,
        credId: registerResponse.rawId,
      ),
      credentialKind: CredentialKind.Fido2,
    );
  }

  /// Signs a user action challenge, returning a [Fido2Assertion] containing
  /// the assertion data.
  ///
  /// This method interacts with a passkey authenticator to authenticate the
  /// user, utilizing the options specified in [PasskeysOptions].
  Future<Fido2Assertion> sign(UserActionChallenge challenge) async {
    try {
      final fido2Assertion = await PasskeyAuthenticator().authenticate(
        AuthenticateRequestType(
          preferImmediatelyAvailableCredentials: false,
          relyingPartyId: challenge.rp.id,
          challenge: challenge.challenge,
          timeout: options.timeout,
          userVerification: challenge.userVerification,
          allowCredentials: List<CredentialType>.from(
            challenge.allowCredentials.webauthn.map(
              (e) => CredentialType(
                type: e.type,
                id: e.id,
                transports: [],
              ),
            ),
          ),
          mediation: MediationType.Required,
        ),
      );

      return Fido2Assertion(
        'Fido2',
        Fido2AssertionData(
          fido2Assertion.clientDataJSON,
          fido2Assertion.rawId,
          fido2Assertion.signature,
          fido2Assertion.authenticatorData,
          fido2Assertion.userHandle,
        ),
      );
    } catch (e) {
      throw const PasskeyValidationException();
    }
  }

  /// Determines whether the device supports passkeys (WebAuthn/FIDO2) for authentication.
  ///
  /// This method performs the following checks:
  ///
  /// 1. **Passkey Authentication Availability**:
  ///    - Utilizes [PasskeyAuthenticator]'s `canAuthenticate` method to determine if the user can currently
  ///      authenticate using passkeys.
  ///    - **Note**: This may return `false` if the user hasn't set up biometrics or a device lock, even if the
  ///      device itself supports passkeys.
  ///
  /// 2. **Hardware Support for Biometrics**:
  ///    - Uses [LocalAuthentication]'s `canCheckBiometrics` to verify if the device has hardware support for
  ///      biometric authentication.
  ///
  /// 3. **Device-Level Authentication Support**:
  ///    - Checks [LocalAuthentication]'s `isDeviceSupported` to determine if device-level authentication is
  ///      set up.
  ///
  /// The method returns `true` if **either**:
  /// - Passkey authentication is available (`canAuthenticate` returns `true`), **or**
  /// - The device has biometric hardware support (`canCheckBiometrics` is `true`) **and** device-level
  ///   authentication is **not** set up (`isDeviceSupported` is `false`).
  ///
  /// This dual-check approach helps eliminate false negatives where the device supports passkeys, but
  /// certain user configurations (like unset biometrics) might otherwise prevent successful authentication.
  ///
  Future<bool> canAuthenticate() async {
    // Ignoring because replacement is not available for all platforms
    // ignore: deprecated_member_use
    final passkeyFuture = PasskeyAuthenticator().canAuthenticate();
    final localAuth = LocalAuthentication();

    final results = await Future.wait<bool>([
      passkeyFuture,
      localAuth.canCheckBiometrics,
      localAuth.isDeviceSupported(),
    ]);

    final canAuthenticateResult = results[0];
    final canCheckBiometrics = results[1];
    final isDeviceSupported = results[2];

    return canAuthenticateResult || (canCheckBiometrics && !isDeviceSupported);
  }
}
