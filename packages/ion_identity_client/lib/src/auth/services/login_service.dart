// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/data_sources/login_data_source.dart';
import 'package:ion_identity_client/src/auth/result_types/login_user_result.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/signer/extensions/passkey_signer_extentions.dart';
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
  /// Returns a [LoginUserResult], which can either be a [LoginUserSuccess] on success
  /// or a specific [LoginUserFailure] type on failure.
  Future<LoginUserResult> loginUser() async {
    final canAuthenticate = await signer.canAuthenticate();
    if (!canAuthenticate) {
      return const PasskeyNotAvailableLoginUserFailure();
    }

    final response = await signer
        .signChallenge(
          dataSource.loginInit(username: username),
          PasskeyValidationLoginUserFailure.new,
        )
        .flatMap(
          (signedChallenge) => dataSource.loginComplete(
            challengeIdentifier: signedChallenge.userActionChallenge.challengeIdentifier,
            assertion: signedChallenge.assertion,
          ),
        )
        .flatMap(
          (r) => tokenStorage.setToken(
            username: username,
            newToken: r.token,
            onError: UnknownLoginUserFailure.new,
          ),
        )
        .run();

    return response.fold(
      (l) => l,
      (r) => LoginUserSuccess(),
    );
  }
}
