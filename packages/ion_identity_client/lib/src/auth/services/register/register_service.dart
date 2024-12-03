// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/credential_request_data.dart';
import 'package:ion_identity_client/src/auth/services/register/data_sources/register_data_source.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/ion_exception.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/password_signer.dart';

class RegisterService {
  RegisterService({
    required this.username,
    required this.dataSource,
    required this.signer,
    required this.passwordSigner,
    required this.tokenStorage,
  });

  final String username;
  final RegisterDataSource dataSource;
  final PasskeysSigner signer;
  final PasswordSigner passwordSigner;
  final TokenStorage tokenStorage;

  /// Registers a new user using the provided username and handles the necessary
  /// cryptographic operations and API interactions.
  ///
  /// This method performs the following steps:
  /// 1. Checks if the device can authenticate using passkeys.
  /// 2. Initiates the registration process with the server.
  /// 3. Generates new credentials info.
  /// 4. Completes the registration with the server.
  /// 5. Stores the received authentication tokens.
  ///
  /// Throws:
  /// - [PasskeyNotAvailableException] if password is not provided and the device cannot authenticate using passkeys.
  /// - Other exceptions may be thrown during API interactions or token storage.
  Future<void> registerUser({String? password}) async {
    final isPasskeyAuth = password == null;
    if (isPasskeyAuth) {
      final passkeyAuthAvailable = await isPasskeyAuthAvailable();
      if (!passkeyAuthAvailable) {
        throw const PasskeyNotAvailableException();
      }
    }
    final userRegistrationChallenge = await dataSource.registerInit(username: username);
    final credentialData = isPasskeyAuth
        ? await signer.register(userRegistrationChallenge)
        : await passwordSigner.getCredentialInfo(
            challenge: userRegistrationChallenge.challenge,
            password: password,
            credentialKind: CredentialKind.PasswordProtectedKey,
          );
    final registrationCompleteResponse = await dataSource.registerComplete(
      credentialData: credentialData,
      temporaryAuthenticationToken: userRegistrationChallenge.temporaryAuthenticationToken,
    );
    await tokenStorage.setTokens(
      username: username,
      newTokens: registrationCompleteResponse.authentication,
    );
  }

  Future<bool> isPasskeyAuthAvailable() async {
    return signer.canAuthenticate();
  }
}
