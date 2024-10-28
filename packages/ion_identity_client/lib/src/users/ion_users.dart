// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/users/get_user_connect_indexers/get_user_connect_indexers_service.dart';
import 'package:ion_identity_client/src/users/get_user_details/get_user_details_service.dart';
import 'package:ion_identity_client/src/users/set_user_connect_relays/set_user_connect_relays_service.dart';

class IONUsersClient {
  IONUsersClient(
    this._getUserDetailsService,
    this._getUserConnectIndexersService,
    this._setUserConnectRelaysService,
  );

  final GetUserDetailsService _getUserDetailsService;
  final GetUserConnectIndexersService _getUserConnectIndexersService;
  final SetUserConnectRelaysService _setUserConnectRelaysService;

  Future<UserDetails> getUserDetails({
    required String userId,
  }) async =>
      _getUserDetailsService.getUserDetails(userId: userId);

  Future<List<String>> getUserConnectIndexers({
    required String userId,
  }) async =>
      _getUserConnectIndexersService.getUserConnectIndexers(userId: userId);

  Future<SetUserConnectRelaysResponse> setUserConnectRelays({
    required String userId,
    required List<String> followeeList,
  }) async =>
      _setUserConnectRelaysService.setUserConnectRelays(
        userId: userId,
        followeeList: followeeList,
      );
}
