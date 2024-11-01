// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/ion_connect_indexers/data_sources/ion_connect_indexers_data_source.dart';

class IONConnectIndexersService {
  IONConnectIndexersService(
    this.username,
    this._dataSource,
  );

  final String username;
  final IONConnectIndexersDataSource _dataSource;

  Future<List<String>> ionConnectIndexers({
    required String userId,
  }) async =>
      _dataSource.fetchIONConnectIndexers(
        username: username,
        userId: userId,
      );
}
