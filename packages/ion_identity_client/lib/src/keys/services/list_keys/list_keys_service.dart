// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/keys/services/list_keys/data_sources/list_keys_data_source.dart';
import 'package:ion_identity_client/src/keys/services/list_keys/models/list_keys_response.f.dart';

class ListKeysService {
  const ListKeysService(
    this._listKeysDataSource,
  );

  final ListKeysDataSource _listKeysDataSource;

  Future<ListKeysResponse> listKeys({
    String? owner,
    int? limit,
    String? paginationToken,
  }) async {
    return _listKeysDataSource.listKeys(
      owner: owner,
      limit: limit,
      paginationToken: paginationToken,
    );
  }
}
