// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/services/login/data_sources/login_data_source.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class LoginService {
  const LoginService({
    required this.username,
    required this.signer,
    required this.dataSource,
    required this.tokenStorage,
  });

  final String username;
  final PasskeysSigner signer;
  final LoginDataSource dataSource;
  final TokenStorage tokenStorage;

  /// Logs in an existing user using the provided username, handling the necessary
  /// API interactions and storing the authentication token securely.
  ///
  /// Throws IonException
  Future<void> loginUser() async {
    final canAuthenticate = await signer.canAuthenticate();
    if (!canAuthenticate) {
      throw const PasskeyNotAvailableException();
    }

    final challenge = await dataSource.loginInit(username: username);
    final assertion = await signer.sign(challenge);
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
