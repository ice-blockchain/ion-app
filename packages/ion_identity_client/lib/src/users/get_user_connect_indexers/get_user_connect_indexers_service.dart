// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/get_user_connect_indexers/data_sources/get_user_connect_indexers_data_source.dart';

class GetUserConnectIndexersService {
  GetUserConnectIndexersService(
    this.username,
    this._dataSource,
  );

  final String username;
  final GetUserConnectIndexersDataSource _dataSource;

  Future<List<String>> getUserConnectIndexers({
    required String userId,
  }) async =>
      _dataSource.getUserConnectIndexers(
        username: username,
        userId: userId,
      );
}
