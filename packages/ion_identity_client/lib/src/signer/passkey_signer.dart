// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
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
              challenge.authenticatorSelection?.authenticatorAttachment ?? 'platform',
          requireResidentKey: challenge.authenticatorSelection?.requireResidentKey ?? false,
          residentKey: challenge.authenticatorSelection?.residentKey ?? 'required',
          userVerification: challenge.authenticatorSelection?.userVerification ?? 'required',
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

  /// Signs a user action challenge, returning a [AssertionRequestData] containing
  /// the assertion data.
  ///
  /// This method interacts with a passkey authenticator to authenticate the
  /// user, utilizing the options specified in [PasskeysOptions].
  Future<AssertionRequestData> sign(
    UserActionChallenge challenge, {
    bool preferImmediatelyAvailableCredentials = false,
  }) async {
    try {
      final fido2Assertion = await PasskeyAuthenticator().authenticate(
        AuthenticateRequestType(
          preferImmediatelyAvailableCredentials: preferImmediatelyAvailableCredentials,
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
      return AssertionRequestData(
        kind: CredentialKind.Fido2,
        credentialAssertion: CredentialAssertionData(
          clientData: fido2Assertion.clientDataJSON,
          credId: fido2Assertion.rawId,
          signature: fido2Assertion.signature,
          authenticatorData: fido2Assertion.authenticatorData,
          userHandle: fido2Assertion.userHandle,
        ),
      );
    } catch (e) {
      throw const PasskeyValidationException();
    }
  }

  Future<bool> canAuthenticate() async {
    // ignore: deprecated_member_use
    return PasskeyAuthenticator().canAuthenticate();
  }
}
