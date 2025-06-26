// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/keys/services/derive/models/derive_request.f.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

class DeriveDataSource {
  const DeriveDataSource(this.username);

  final String username;

  static String deriveKeyPath(String keyId) => '/keys/$keyId/derive';

  UserActionSigningRequest buildDeriveSigningRequest({
    required String keyId,
    required String domain,
    required String seed,
  }) {
    return UserActionSigningRequest(
      username: username,
      method: HttpMethod.post,
      path: deriveKeyPath(keyId),
      body: DeriveRequest(
        domain: domain,
        seed: seed,
      ).toJson(),
    );
  }
}
