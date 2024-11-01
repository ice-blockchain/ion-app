// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/set_ion_connect_relays/data_sources/set_ion_connect_relays_data_source.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/models/set_ion_connect_relays_request.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/models/set_ion_connect_relays_response.dart';

class SetIonConnectRelaysService {
  SetIonConnectRelaysService(
    this.username,
    this._dataSource,
  );

  final String username;
  final SetUserConnectRelaysDataSource _dataSource;

  Future<SetIonConnectRelaysResponse> setIonConnectRelays({
    required String userId,
    required List<String> followeeList,
  }) async {
    final request = SetIonConnectRelaysRequest(followeeList: followeeList);

    return _dataSource.setIonConnectRelays(
      username: username,
      userId: userId,
      request: request,
    );
  }
}
