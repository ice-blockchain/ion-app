// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_clients/auth_client_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_clients/users_client_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_clients/wallets_client_service_locator.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class ClientsServiceLocator {
  factory ClientsServiceLocator() {
    return _instance;
  }

  ClientsServiceLocator._internal();

  static final ClientsServiceLocator _instance = ClientsServiceLocator._internal();

  final Map<String, IONIdentityClient> _clients = {};

  IONIdentityClient ionIdentityClient({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
  }) {
    var client = _clients[username];
    if (client == null) {
      client = IONIdentityClient(
        auth: AuthClientServiceLocator().auth(
          username: username,
          config: config,
          signer: signer,
        ),
        wallets: WalletsClientServiceLocator().wallets(
          username: username,
          config: config,
          signer: signer,
        ),
        users: UsersClientServiceLocator().users(
          username: username,
          config: config,
        ),
      );
      _clients[username] = client;
    }
    return client;
  }
}
