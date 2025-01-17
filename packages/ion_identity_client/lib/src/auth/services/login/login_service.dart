// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/dtos/private_key_data.c.dart';
import 'package:ion_identity_client/src/auth/services/login/data_sources/login_data_source.dart';
import 'package:ion_identity_client/src/core/network/network_exception.dart';
import 'package:ion_identity_client/src/core/storage/private_key_storage.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';

class LoginService {
  const LoginService({
    required this.username,
    required this.identitySigner,
    required this.dataSource,
    required this.tokenStorage,
    required this.privateKeyStorage,
  });

  final String username;
  final IdentitySigner identitySigner;
  final LoginDataSource dataSource;
  final TokenStorage tokenStorage;
  final PrivateKeyStorage privateKeyStorage;

  /// Initializes the login process for the specified [username].
  ///
  /// 1. Invokes loginInit to retrieve the [UserActionChallenge] data.
  /// 2. Checks whether the challenge's [UserActionChallenge.supportedCredentialKinds] contains [CredentialKind.Fido2].
  ///    - If **Fido2** is not supported, passkey authentication is not available for the account.
  ///    - In this case, checks if the user is a password-based user by examining the `passwordProtectedKey` field.
  ///    - If an encrypted private key exists, it is securely stored.
  ///
  /// This flow ensures that if **Fido2**-based authentication is not available,
  /// a password-based credential (if present) is captured and stored appropriately.
  Future<void> verifyUserLoginFlow() async {
    try {
      final challenge = await dataSource.loginInit(username: username);
      if (challenge.supportedCredentialKinds
              .any((SupportedCredentialKinds2 credKind) => credKind.kind == CredentialKind.Fido2) ==
          false) {
        final credentialDescriptor = challenge.allowCredentials.passwordProtectedKey?.firstOrNull;
        final encryptedPrivateKey = credentialDescriptor?.encryptedPrivateKey;
        if (encryptedPrivateKey != null) {
          await privateKeyStorage.setPrivateKey(
            username: username,
            privateKeyData: PrivateKeyData(),
          );
        }
      }
    } on RequestExecutionException catch (e) {
      final dioException = e.error is DioException ? e.error as DioException : null;

      if (dioException?.response?.statusCode == 403 &&
          dioException?.response?.data['error']['message'] == '2FA_REQUIRED') {
        final twoFAOptionsCount = dioException?.response?.data['data']['n'] as int;
        await privateKeyStorage.setPrivateKey(
          username: username,
          privateKeyData: PrivateKeyData(),
        );
        throw TwoFARequiredException(twoFAOptionsCount);
      }
      rethrow;
    }
  }

  /// Logs in an existing user using the provided username, handling the necessary
  /// API interactions and storing the authentication token securely.
  ///
  /// This method performs the following steps:
  /// 1. Checks if the device can authenticate using passkeys.
  /// 2. Initiates the login process with the server.
  /// 3. Generates a passkey assertion.
  /// 4. Completes the login with the server.
  /// 5. Stores the received authentication tokens.
  ///
  /// Throws:
  /// - [PasskeyNotAvailableException] if the device cannot authenticate using passkeys.
  /// - [UnauthenticatedException] if the login credentials are invalid.
  /// - [UserDeactivatedException] if the user account has been deactivated.
  /// - [UserNotFoundException] if the user account does not exist.
  /// - [PasskeyValidationException] if the passkey validation fails.
  /// - [UnknownIONIdentityException] for any other unexpected errors during the login process.
  Future<void> loginUser({
    required OnVerifyIdentity<AssertionRequestData> onVerifyIdentity,
    required List<TwoFAType> twoFATypes,
    bool preferImmediatelyAvailableCredentials = false,
  }) async {
    final challenge = await dataSource.loginInit(username: username, twoFATypes: twoFATypes);
    final assertion = await onVerifyIdentity(
      onPasskeyFlow: () {
        return identitySigner.signWithPasskey(
          challenge,
          preferImmediatelyAvailableCredentials: preferImmediatelyAvailableCredentials,
        );
      },
      onPasswordFlow: ({required String password}) {
        final credentialDescriptor = identitySigner.extractPasswordProtectedCredentials(challenge);
        return identitySigner.signWithPassword(
          challenge: challenge.challenge,
          encryptedPrivateKey: credentialDescriptor.encryptedPrivateKey!,
          credentialId: credentialDescriptor.id,
          credentialKind: CredentialKind.PasswordProtectedKey,
          password: password,
        );
      },
      onBiometricsFlow: ({required String localisedReason}) {
        final credentialDescriptor = identitySigner.extractPasswordProtectedCredentials(challenge);
        return identitySigner.signWithBiometrics(
          challenge: challenge.challenge,
          username: username,
          credentialId: credentialDescriptor.id,
          credentialKind: CredentialKind.PasswordProtectedKey,
          localisedReason: localisedReason,
        );
      },
    );

    final tokens = await dataSource.loginComplete(
      challengeIdentifier: challenge.challengeIdentifier,
      assertion: assertion,
    );
    await tokenStorage.setTokens(
      username: username,
      newTokens: tokens,
    );
  }
}
