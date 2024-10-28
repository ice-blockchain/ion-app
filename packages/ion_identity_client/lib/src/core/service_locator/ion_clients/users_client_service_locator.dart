// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_service_locator.dart';
import 'package:ion_identity_client/src/users/get_user_connect_indexers/data_sources/get_user_connect_indexers_data_source.dart';
import 'package:ion_identity_client/src/users/get_user_connect_indexers/get_user_connect_indexers_service.dart';
import 'package:ion_identity_client/src/users/get_user_details/data_sources/get_user_details_data_source.dart';
import 'package:ion_identity_client/src/users/get_user_details/get_user_details_service.dart';
import 'package:ion_identity_client/src/users/ion_users.dart';
import 'package:ion_identity_client/src/users/set_user_connect_relays/data_sources/set_user_connect_relays_data_source.dart';
import 'package:ion_identity_client/src/users/set_user_connect_relays/set_user_connect_relays_service.dart';

mixin UsersClientServiceLocator {
  IONUsersClient getUsersClient({
    required String username,
    required IonClientConfig config,
  }) =>
      IONUsersClient(
        _getUserDetailsService(
          username: username,
          config: config,
        ),
        _getUserConnectIndexersService(
          username: username,
          config: config,
        ),
        _setUserConnectRelaysService(
          username: username,
          config: config,
        ),
      );

  GetUserDetailsService _getUserDetailsService({
    required String username,
    required IonClientConfig config,
  }) =>
      GetUserDetailsService(
        username,
        GetUserDetailsDataSource(
          IonServiceLocator.getNetworkClient(config: config),
          IonServiceLocator.getTokenStorage(),
        ),
      );

  GetUserConnectIndexersService _getUserConnectIndexersService({
    required String username,
    required IonClientConfig config,
  }) =>
      GetUserConnectIndexersService(
        username,
        GetUserConnectIndexersDataSource(
          IonServiceLocator.getNetworkClient(config: config),
          IonServiceLocator.getTokenStorage(),
        ),
      );

  SetUserConnectRelaysService _setUserConnectRelaysService({
    required String username,
    required IonClientConfig config,
  }) =>
      SetUserConnectRelaysService(
        username,
        SetUserConnectRelaysDataSource(
          IonServiceLocator.getNetworkClient(config: config),
          IonServiceLocator.getTokenStorage(),
        ),
      );
}
