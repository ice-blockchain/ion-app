// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/users/available_ion_connect_relays/data_sources/available_ion_connect_relays_data_source.dart';
import 'package:ion_identity_client/src/users/models/ion_connect_relay_info.f.dart';

class AvailableIONConnectRelaysService {
  AvailableIONConnectRelaysService(
    this.username,
    this._dataSource,
  );

  final String username;
  final AvailableIONConnectRelaysDataSource _dataSource;

  Future<List<IonConnectRelayInfo>> allAvailableIonConnectRelays({
    required String userId,
    required String relayUrl,
  }) =>
      _dataSource.fetchAllAvailableIONConnectRelays(
        username: username,
        userId: userId,
        relayUrl: relayUrl,
      );
}
