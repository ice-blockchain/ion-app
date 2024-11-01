// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/users/ion_connect_indexers/get_user_connect_indexers_service.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/set_ion_connect_relays_service.dart';
import 'package:ion_identity_client/src/users/user_details/user_details_service.dart';

class IONIdentityUsers {
  IONIdentityUsers(
    this._getUserDetailsService,
    this._ionConnectIndexersService,
    this._setIONConnectRelaysService,
  );

  final UserDetailsService _getUserDetailsService;
  final IONConnectIndexersService _ionConnectIndexersService;
  final SetIONConnectRelaysService _setIONConnectRelaysService;

  Future<UserDetails> details({
    required String userId,
  }) async =>
      _getUserDetailsService.details(userId: userId);

  Future<List<String>> ionConnectIndexers({
    required String userId,
  }) async =>
      _ionConnectIndexersService.ionConnectIndexers(userId: userId);

  Future<SetIONConnectRelaysResponse> setIONConnectRelays({
    required String userId,
    required List<String> followeeList,
  }) async =>
      _setIONConnectRelaysService.setIONConnectRelays(
        userId: userId,
        followeeList: followeeList,
      );
}
