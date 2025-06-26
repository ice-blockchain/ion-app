// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/keys/services/update_key/models/update_key_request.f.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';

class UpdateKeyDataSource {
  const UpdateKeyDataSource(this.username);

  final String username;

  static const updateKeyPath = '/keys';

  UserActionSigningRequest buildUpdateKeySigningRequest({
    required String keyId,
    required String name,
  }) {
    return UserActionSigningRequest(
      username: username,
      method: HttpMethod.put,
      path: '$updateKeyPath/$keyId',
      body: UpdateKeyRequest(
        name: name,
      ).toJson(),
    );
  }
}
