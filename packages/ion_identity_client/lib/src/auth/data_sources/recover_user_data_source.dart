// SPDX-License-Identifier: ice License 1.0

import 'package:fpdart/fpdart.dart';
import 'package:ion_identity_client/src/auth/result_types/recover_user_result.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/dtos/dtos.dart';

class RecoverUserDataSource {
  RecoverUserDataSource({
    required this.networkClient,
  });

  final NetworkClient networkClient;

  static const createDelegatedRecoveryChallengePath = '/auth/recover/user/delegated';
  static const recoverUserPath = '/auth/recover/user';

  TaskEither<RecoverUserFailure, UserRegistrationChallenge> createDelegatedRecoveryChallenge({
    required String username,
    required String credentialId,
  }) {
    return networkClient
        .post(
          createDelegatedRecoveryChallengePath,
          data: {
            'username': username,
            'credentialId': credentialId,
          },
          decoder: UserRegistrationChallenge.fromJson,
        )
        .mapLeft(CreateChallengeRequestRecoverUserFailure.new);
  }

  TaskEither<RecoverUserFailure, JsonObject> recoverUser({
    required JsonObject recoveryData,
    required String temporaryAuthenticationToken,
  }) {
    return networkClient
        .post(
          recoverUserPath,
          data: recoveryData,
          headers: RequestHeaders.getTokenHeader(token: temporaryAuthenticationToken),
          decoder: (json) => json,
        )
        .mapLeft(RecoverUserRequestRecoverUserFailure.new);
  }
}
