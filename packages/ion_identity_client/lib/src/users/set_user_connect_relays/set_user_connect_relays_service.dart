// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/set_user_connect_relays/data_sources/set_user_connect_relays_data_source.dart';
import 'package:ion_identity_client/src/users/set_user_connect_relays/models/set_user_connect_relays_request.dart';
import 'package:ion_identity_client/src/users/set_user_connect_relays/models/set_user_connect_relays_response.dart';

class SetUserConnectRelaysService {
  SetUserConnectRelaysService(
    this.username,
    this._dataSource,
  );

  final String username;
  final SetUserConnectRelaysDataSource _dataSource;

  Future<SetUserConnectRelaysResponse> setUserConnectRelays({
    required String userId,
    required List<String> followeeList,
  }) async {
    final request = SetUserConnectRelaysRequest(followeeList: followeeList);

    return _dataSource.setUserConnectRelays(
      username: username,
      userId: userId,
      request: request,
    );
  }
}
