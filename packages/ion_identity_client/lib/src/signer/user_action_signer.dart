// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:ion_identity_client/src/signer/data_sources/user_action_signer_data_source.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

class UserActionSigner {
  const UserActionSigner({
    required this.dataSource,
    required this.passkeysSigner,
  });

  final UserActionSignerDataSource dataSource;
  final PasskeysSigner passkeysSigner;

  Future<T> execute<T>(
    UserActionSigningRequest request,
    T Function(JsonObject) responseDecoder,
  ) async {
    final challenge = await dataSource.createUserActionSigningChallenge(
      request.username,
      request.initRequest,
    );

    final assertion = await passkeysSigner.sign(challenge);

    final signedSignature = await dataSource.createUserActionSignature(
      request.username,
      assertion,
      challenge.challengeIdentifier,
    );

    return dataSource.makeRequest(
      request.username,
      signedSignature,
      request,
      responseDecoder,
    );
  }
}
