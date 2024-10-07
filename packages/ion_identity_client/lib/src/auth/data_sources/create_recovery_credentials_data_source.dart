// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/dtos/credential_challenge.dart';
import 'package:ion_identity_client/src/auth/dtos/credential_request_data.dart';
import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/core/types/request_headers.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

const recoveryKeyBody = {'kind': 'RecoveryKey'};

class CreateRecoveryCredentialsDataSource {
  CreateRecoveryCredentialsDataSource({
    required this.networkClient,
    required this.tokenStorage,
  });

  static const createCredentialInitPath = '/auth/credentials/init';
  static const createCredentialPath = '/auth/credentials';

  final NetworkClient networkClient;
  final TokenStorage tokenStorage;

  TaskEither<CreateRecoveryCredentialsFailure, CredentialChallenge> createCredentialInit({
    required String username,
  }) {
    final token = tokenStorage.getToken(username: username);
    if (token == null) {
      return TaskEither.left(
        CreateCredentialInitCreateRecoveryCredentialsFailure(
          RequestExecutionNetworkFailure(401, StackTrace.current),
        ),
      );
    }

    return networkClient
        .post(
          createCredentialInitPath,
          data: recoveryKeyBody,
          decoder: CredentialChallenge.fromJson,
          headers: RequestHeaders.getAuthorizationHeader(token: token.token),
        )
        .mapLeft(CreateCredentialInitCreateRecoveryCredentialsFailure.new);
  }

  UserActionSigningRequest buildCreateCredentialSigningRequest(
    String username,
    CredentialRequestData credentialRequestData,
  ) {
    return UserActionSigningRequest(
      username: username,
      method: HttpMethod.post,
      path: createCredentialPath,
      body: credentialRequestData.toJson(),
    );
  }
}
