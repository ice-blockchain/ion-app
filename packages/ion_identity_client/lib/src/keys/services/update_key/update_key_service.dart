// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/keys/services/update_key/data_sources/update_key_data_source.dart';

class UpdateKeyService {
  UpdateKeyService(
    this._updateKeyDataSource,
  );

  final UpdateKeyDataSource _updateKeyDataSource;

  Future<KeyResponse> updateKey({
    required String keyId,
    required String name,
    required UserActionSignerNew signer,
  }) async {
    final request = _updateKeyDataSource.buildUpdateKeySigningRequest(
      keyId: keyId,
      name: name,
    );

    return signer.sign<KeyResponse>(request, KeyResponse.fromJson);
  }
}
