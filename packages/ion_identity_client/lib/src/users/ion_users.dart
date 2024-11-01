// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/users/ion_connect_indexers/get_user_connect_indexers_service.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/set_ion_connect_relays_service.dart';
import 'package:ion_identity_client/src/users/user_details/user_details_service.dart';

class IONUsersClient {
  IONUsersClient(
    this._getUserDetailsService,
    this._ionConnectIndexersService,
    this._setIonConnectRelaysService,
  );

  final UserDetailsService _getUserDetailsService;
  final IonConnectIndexersService _ionConnectIndexersService;
  final SetIonConnectRelaysService _setIonConnectRelaysService;

  Future<UserDetails> details({
    required String userId,
  }) async =>
      _getUserDetailsService.details(userId: userId);

  Future<List<String>> ionConnectIndexers({
    required String userId,
  }) async =>
      _ionConnectIndexersService.ionConnectIndexers(userId: userId);

  Future<SetIonConnectRelaysResponse> setIonConnectRelays({
    required String userId,
    required List<String> followeeList,
  }) async =>
      _setIonConnectRelaysService.setIonConnectRelays(
        userId: userId,
        followeeList: followeeList,
      );
}
