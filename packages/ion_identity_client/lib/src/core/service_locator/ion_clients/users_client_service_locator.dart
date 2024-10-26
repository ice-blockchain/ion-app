// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_service_locator.dart';
import 'package:ion_identity_client/src/users/get_user_details/data_sources/get_user_details_data_source.dart';
import 'package:ion_identity_client/src/users/get_user_details/get_user_details_service.dart';
import 'package:ion_identity_client/src/users/ion_users.dart';

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
}
