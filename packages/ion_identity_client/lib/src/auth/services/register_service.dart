// SPDX-License-Identifier: ice License 1.0

import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/auth/data_sources/register_data_source.dart';
import 'package:ion_identity_client/src/auth/result_types/register_user_result.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class RegisterService {
  RegisterService({
    required this.username,
    required this.dataSource,
    required this.signer,
    required this.tokenStorage,
  });

  final String username;
  final RegisterDataSource dataSource;
  final PasskeysSigner signer;
  final TokenStorage tokenStorage;

  /// Registers a new user using the provided username and handles the necessary
  /// cryptographic operations and API interactions.
  ///
  /// Returns a [RegisterUserResult], which can either be a [RegisterUserSuccess]
  /// on success or a specific [RegisterUserFailure] type on failure.
  Future<RegisterUserResult> registerUser() async {
    final canAuthenticate = await signer.canAuthenticate();
    if (!canAuthenticate) {
      return const PasskeyNotAvailableRegisterUserFailure();
    }

    final result = await dataSource
        .registerInit(username: username)
        .flatMap(
          (userRegistrationChallenge) => TaskEither<RegisterUserFailure, Fido2Attestation>.tryCatch(
            () => signer.register(userRegistrationChallenge),
            PasskeyValidationRegisterUserFailure.new,
          ).flatMap(
            (attestation) => dataSource.registerComplete(
              attestation: attestation,
              temporaryAuthenticationToken: userRegistrationChallenge.temporaryAuthenticationToken,
            ),
          ),
        )
        .flatMap(
          (r) => TaskEither.tryCatch(
            () => tokenStorage.setTokens(
              username: username,
              newTokens: r.authentication,
            ),
            (error, _) => UnknownRegisterUserFailure(error),
          ),
        )
        .run();

    return result.fold(
      (l) => l,
      (r) => RegisterUserSuccess(),
    );
  }
}
