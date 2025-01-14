// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/signer/dtos/assertion_request_data.c.dart';
import 'package:ion_identity_client/src/signer/dtos/user_action_challenge.c.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/password_signer.dart';

class IdentitySigner {
  IdentitySigner({
    required this.passkeySigner,
    required this.passwordSigner,
  });

  final PasskeysSigner passkeySigner;
  final PasswordSigner passwordSigner;

  Future<CredentialRequestData> registerWithPasskey(UserRegistrationChallenge challenge) async {
    return passkeySigner.register(challenge);
  }

  Future<CredentialRequestData> registerWithPassword({
    required String challenge,
    required String password,
    required String username,
    required CredentialKind credentialKind,
  }) async {
    return passwordSigner.createCredentialInfo(
      challenge: challenge,
      password: password,
      username: username,
      credentialKind: credentialKind,
    );
  }

  Future<AssertionRequestData> signWithPasskey(
    UserActionChallenge challenge, {
    bool preferImmediatelyAvailableCredentials = false,
  }) async {
    return passkeySigner.sign(
      challenge,
      preferImmediatelyAvailableCredentials: preferImmediatelyAvailableCredentials,
    );
  }

  Future<AssertionRequestData> signWithPassword({
    required String challenge,
    required String encryptedPrivateKey,
    required String password,
    required String credentialId,
    required CredentialKind credentialKind,
  }) async {
    return passwordSigner.signWithPassword(
      challenge: challenge,
      encryptedPrivateKey: encryptedPrivateKey,
      password: password,
      credentialKind: credentialKind,
      credentialId: credentialId,
    );
  }

  Future<AssertionRequestData> signWithBiometrics({
    required String username,
    required String localisedReason,
    required String challenge,
    required String credentialId,
    required CredentialKind credentialKind,
  }) async {
    return passwordSigner.signWithBiometrics(
      username: username,
      localisedReason: localisedReason,
      challenge: challenge,
      credentialKind: credentialKind,
      credentialId: credentialId,
    );
  }

  Future<bool> isPasskeyAvailable() {
    return passkeySigner.canAuthenticate();
  }

  Future<void> rejectToUseBiometrics(String username) {
    return passwordSigner.rejectToUseBiometrics(username);
  }

  Future<void> enrollToUseBiometrics({
    required String username,
    required String localisedReason,
  }) {
    return passwordSigner.enrollToUseBiometrics(
      username: username,
      localisedReason: localisedReason,
    );
  }
}
