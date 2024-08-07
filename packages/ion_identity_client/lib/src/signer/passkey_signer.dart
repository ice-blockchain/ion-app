import 'dart:convert';

import 'package:ion_identity_client/src/signer/dtos/fido_2_assertion.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_assertion_data.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_attestation.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_attestation_data.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_challenge.dart';
import 'package:ion_identity_client/src/signer/dtos/user_registration_challenge.dart';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';

const int defaultWaitTimeout = 60000;

class PasskeysOptions {
  PasskeysOptions(this.timeout);

  final int? timeout;
}

class PasskeysSigner {
  PasskeysSigner([this.options]);

  PasskeysOptions? options;

  Future<Fido2Attestation> register(UserRegistrationChallenge challenge) async {
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
        timeout: options?.timeout ?? defaultWaitTimeout,
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

    return Fido2Attestation(
      Fido2AttestationData(
        registerResponse.attestationObject,
        registerResponse.clientDataJSON,
        registerResponse.rawId,
      ),
      'Fido2',
    );
  }

  Future<Fido2Assertion> sign(UserActionChallenge challenge) async {
    final fido2Assertion = await PasskeyAuthenticator().authenticate(
      AuthenticateRequestType(
        relyingPartyId: challenge.rp.id,
        challenge: challenge.challenge,
        timeout: options?.timeout ?? defaultWaitTimeout,
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
  }
}
