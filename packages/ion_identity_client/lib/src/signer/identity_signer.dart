// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/dtos/fido_2_assertion.dart';
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

  Future<Fido2Assertion> signWithPasskey(UserActionChallenge challenge) async {
    return passkeySigner.sign(challenge);
  }

  Future<bool> isPasskeyAvailable() async {
    return passkeySigner.canAuthenticate();
  }
}
