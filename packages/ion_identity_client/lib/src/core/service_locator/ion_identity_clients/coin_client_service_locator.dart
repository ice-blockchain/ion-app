// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/coins/ion_identity_coins.dart';
import 'package:ion_identity_client/src/coins/services/data_sources/get_coins_data_source.dart';
import 'package:ion_identity_client/src/coins/services/get_coins_service.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_clients/auth_client_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_service_locator.dart';

class CoinsClientServiceLocator {
  factory CoinsClientServiceLocator() {
    return _instance;
  }

  CoinsClientServiceLocator._internal();

  static final CoinsClientServiceLocator _instance = CoinsClientServiceLocator._internal();

  IONIdentityCoins coins({
    required String username,
    required IONIdentityConfig config,
  }) {
    return IONIdentityCoins(
      username: username,
      getCoinsService: getCoins(username: username, config: config),
      extractUserIdService: AuthClientServiceLocator().extractUserId(),
    );
  }

  GetCoinsService getCoins({
    required String username,
    required IONIdentityConfig config,
  }) {
    return GetCoinsService(
      getCoinsDataSource: GetCoinsDataSource(
        networkClient: IONIdentityServiceLocator.networkClient(config: config),
        tokenStorage: IONIdentityServiceLocator.tokenStorage(),
      ),
    );
  }
}
