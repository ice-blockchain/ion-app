// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/keys/services/create_key/data_sources/create_key_data_source.dart';

class CreateKeyService {
  CreateKeyService(
    this._createKeyDataSource,
  );

  final CreateKeyDataSource _createKeyDataSource;

  Future<KeyResponse> createKey({
    required String scheme,
    required String curve,
    required String name,
    required UserActionSignerNew signer,
  }) async {
    final request = _createKeyDataSource.buildCreateKeySigningRequest(
      scheme: scheme,
      curve: curve,
      name: name,
    );

    return signer.sign<KeyResponse>(request, KeyResponse.fromJson);
  }
}
