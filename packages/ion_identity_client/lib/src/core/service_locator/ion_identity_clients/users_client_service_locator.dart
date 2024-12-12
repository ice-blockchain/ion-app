// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_clients/auth_client_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_service_locator.dart';
import 'package:ion_identity_client/src/users/ion_connect_indexers/data_sources/ion_connect_indexers_data_source.dart';
import 'package:ion_identity_client/src/users/ion_connect_indexers/get_user_connect_indexers_service.dart';
import 'package:ion_identity_client/src/users/ion_identity_users.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/data_sources/set_ion_connect_relays_data_source.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/set_ion_connect_relays_service.dart';
import 'package:ion_identity_client/src/users/user_details/data_sources/user_details_data_source.dart';
import 'package:ion_identity_client/src/users/user_details/user_details_service.dart';

class UsersClientServiceLocator {
  factory UsersClientServiceLocator() {
    return _instance;
  }

  UsersClientServiceLocator._internal();

  static final UsersClientServiceLocator _instance = UsersClientServiceLocator._internal();

  IONIdentityUsers users({
    required String username,
    required IONIdentityConfig config,
  }) =>
      IONIdentityUsers(
        username,
        _userDetails(
          username: username,
          config: config,
        ),
        _ionConnectIndexers(
          username: username,
          config: config,
        ),
        _setIONConnectRelays(
          username: username,
          config: config,
        ),
        AuthClientServiceLocator().extractUserId(),
      );

  UserDetailsService _userDetails({
    required String username,
    required IONIdentityConfig config,
  }) =>
      UserDetailsService(
        username,
        UserDetailsDataSource(
          IONIdentityServiceLocator.networkClient(config: config),
          IONIdentityServiceLocator.identityStorage(),
        ),
      );

  IONConnectIndexersService _ionConnectIndexers({
    required String username,
    required IONIdentityConfig config,
  }) =>
      IONConnectIndexersService(
        username,
        IONConnectIndexersDataSource(
          IONIdentityServiceLocator.networkClient(config: config),
          IONIdentityServiceLocator.identityStorage(),
        ),
      );

  SetIONConnectRelaysService _setIONConnectRelays({
    required String username,
    required IONIdentityConfig config,
  }) =>
      SetIONConnectRelaysService(
        username,
        SetIONConnectRelaysDataSource(
          IONIdentityServiceLocator.networkClient(config: config),
          IONIdentityServiceLocator.identityStorage(),
        ),
      );
}
