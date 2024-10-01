// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
import 'package:ion_identity_client/src/auth/result_types/register_user_result.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

class RegisterDataSource {
  const RegisterDataSource({
    required this.networkClient,
  });

  final NetworkClient networkClient;

  static const registerInitPath = '/auth/registration/delegated';
  static const registerCompletePath = '/auth/registration/enduser';

  TaskEither<RegisterUserFailure, UserRegistrationChallenge> registerInit({
    required String username,
  }) {
    final requestData = RegisterInitRequest(email: username);

    return networkClient
        .post(
          registerInitPath,
          data: requestData.toJson(),
          decoder: UserRegistrationChallenge.fromJson,
        )
        .mapLeft(
          (l) => switch (l) {
            ResponseFormatNetworkFailure() => UserAlreadyExistsRegisterUserFailure(),
            _ => const UnknownRegisterUserFailure(),
          },
        );
  }

  TaskEither<RegisterUserFailure, RegistrationCompleteResponse> registerComplete({
    required Fido2Attestation attestation,
    required String temporaryAuthenticationToken,
  }) {
    return networkClient.post(
      registerCompletePath,
      data: SignedChallenge(firstFactorCredential: attestation).toJson(),
      decoder: RegistrationCompleteResponse.fromJson,
      headers: {
        ...RequestHeaders.getAuthorizationHeader(token: temporaryAuthenticationToken),
      },
    ).mapLeft(
      // TODO: find a complete list of user registration failures
      (l) => switch (l) {
        ResponseFormatNetworkFailure() => UserAlreadyExistsRegisterUserFailure(),
        _ => const UnknownRegisterUserFailure(),
      },
    );
  }
}
