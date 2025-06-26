// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/set_ion_connect_relays/data_sources/set_ion_connect_relays_data_source.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/models/set_ion_connect_relays_request.f.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/models/set_ion_connect_relays_response.f.dart';

class SetIONConnectRelaysService {
  SetIONConnectRelaysService(
    this.username,
    this._dataSource,
  );

  final String username;
  final SetIONConnectRelaysDataSource _dataSource;

  Future<SetIONConnectRelaysResponse> setIONConnectRelays({
    required String userId,
    required List<String> followeeList,
  }) async {
    final request = SetIONConnectRelaysRequest(followeeList: followeeList);

    return _dataSource.setIONConnectRelays(
      username: username,
      userId: userId,
      request: request,
    );
  }
}
