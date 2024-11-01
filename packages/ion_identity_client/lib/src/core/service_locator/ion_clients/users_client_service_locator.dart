// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_service_locator.dart';
import 'package:ion_identity_client/src/users/ion_connect_indexers/data_sources/ion_connect_indexers_data_source.dart';
import 'package:ion_identity_client/src/users/ion_connect_indexers/get_user_connect_indexers_service.dart';
import 'package:ion_identity_client/src/users/ion_users.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/data_sources/set_ion_connect_relays_data_source.dart';
import 'package:ion_identity_client/src/users/set_ion_connect_relays/set_ion_connect_relays_service.dart';
import 'package:ion_identity_client/src/users/user_details/data_sources/user_details_data_source.dart';
import 'package:ion_identity_client/src/users/user_details/user_details_service.dart';

mixin UsersClientServiceLocator {
  IONUsersClient users({
    required String username,
    required IonClientConfig config,
  }) =>
      IONUsersClient(
        _userDetails(
          username: username,
          config: config,
        ),
        _ionConnectIndexers(
          username: username,
          config: config,
        ),
        _setIonConnectRelays(
          username: username,
          config: config,
        ),
      );

  UserDetailsService _userDetails({
    required String username,
    required IonClientConfig config,
  }) =>
      UserDetailsService(
        username,
        UserDetailsDataSource(
          IonServiceLocator.getNetworkClient(config: config),
          IonServiceLocator.getTokenStorage(),
        ),
      );

  IonConnectIndexersService _ionConnectIndexers({
    required String username,
    required IonClientConfig config,
  }) =>
      IonConnectIndexersService(
        username,
        IonConnectIndexersDataSource(
          IonServiceLocator.getNetworkClient(config: config),
          IonServiceLocator.getTokenStorage(),
        ),
      );

  SetIonConnectRelaysService _setIonConnectRelays({
    required String username,
    required IonClientConfig config,
  }) =>
      SetIonConnectRelaysService(
        username,
        SetUserConnectRelaysDataSource(
          IonServiceLocator.getNetworkClient(config: config),
          IonServiceLocator.getTokenStorage(),
        ),
      );
}
