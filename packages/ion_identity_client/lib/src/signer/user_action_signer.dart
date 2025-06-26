// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/credential_request_data.j.dart';
import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/data_sources/user_action_signer_data_source.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

class UserActionSigner {
  const UserActionSigner({
    required this.dataSource,
    required this.identitySigner,
  });

  final UserActionSignerDataSource dataSource;
  final IdentitySigner identitySigner;

  /// Signs a user action using a passkey flow.
  ///
  /// It obtains a signing challenge, uses the identitySigner to sign the challenge
  /// with a passkey, and then completes the request.
  Future<T> signWithPasskey<T>(
    UserActionSigningRequest request,
    T Function(JsonObject) responseDecoder,
  ) async {
    return _sign(
      request: request,
      responseDecoder: responseDecoder,
      // The assertion is obtained directly from signWithPasskey.
      obtainAssertion: (challenge) async {
        return identitySigner.signWithPasskey(challenge);
      },
    );
  }

  /// Signs a user action using a password flow.
  ///
  /// It obtains a signing challenge, checks for a password-protected credential,
  /// uses the identitySigner to create the assertion with the given password,
  /// and completes the request.
  Future<T> signWithPassword<T>(
    UserActionSigningRequest request,
    T Function(JsonObject) responseDecoder,
    String password,
  ) async {
    return _sign(
      request: request,
      responseDecoder: responseDecoder,
      // The assertion here is obtained by using the password to unlock
      // a password-protected key. If this key is unavailable, an exception is thrown.
      obtainAssertion: (challenge) async {
        final credentialDescriptor = identitySigner.extractPasswordProtectedCredentials(challenge);

        return identitySigner.signWithPassword(
          challenge: challenge.challenge,
          encryptedPrivateKey: credentialDescriptor.encryptedPrivateKey!,
          credentialId: credentialDescriptor.id,
          credentialKind: CredentialKind.PasswordProtectedKey,
          password: password,
        );
      },
    );
  }

  Future<T> signWithBiometrics<T>(
    UserActionSigningRequest request,
    T Function(JsonObject) responseDecoder,
    String localisedReason,
    String localisedCancel,
  ) async {
    return _sign(
      request: request,
      responseDecoder: responseDecoder,
      obtainAssertion: (challenge) async {
        final credentialDescriptor = identitySigner.extractPasswordProtectedCredentials(challenge);

        return identitySigner.signWithBiometrics(
          challenge: challenge.challenge,
          username: request.username,
          encryptedPrivateKey: credentialDescriptor.encryptedPrivateKey!,
          credentialId: credentialDescriptor.id,
          credentialKind: CredentialKind.PasswordProtectedKey,
          localisedReason: localisedReason,
          localisedCancel: localisedCancel,
        );
      },
    );
  }

  /// A private helper method that encapsulates the shared logic for both signWithPasskey and signWithPassword.
  ///
  /// Steps:
  /// 1. Obtain a user action signing challenge from the data source.
  /// 2. Use the provided obtainAssertion callback to get the assertion.
  /// 3. Create a signed signature from the data source.
  /// 4. Make the final request with the signed signature.
  Future<T> _sign<T>({
    required UserActionSigningRequest request,
    required T Function(JsonObject) responseDecoder,
    required Future<AssertionRequestData> Function(UserActionChallenge) obtainAssertion,
  }) async {
    // 1. Create the signing challenge.
    final challenge = await dataSource.createUserActionSigningChallenge(
      request.username,
      request.initRequest,
    );

    // 2. Obtain the assertion using the provided callback (either passkey or password flow).
    final assertion = await obtainAssertion(challenge);

    // 3. Use the assertion to create a signed signature.
    final signedSignature = await dataSource.createUserActionSignature(
      request.username,
      assertion,
      challenge.challengeIdentifier,
    );

    // 4. Make the final request, utilizing the signed signature and returning the decoded response.
    return dataSource.makeRequest(
      request.username,
      signedSignature,
      request,
      responseDecoder,
    );
  }
}
