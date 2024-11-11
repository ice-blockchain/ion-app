// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/service_locator/clients_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/network_service_locator.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class IONIdentityServiceLocator {
  static NetworkClient networkClient({
    required IONIdentityConfig config,
  }) =>
      NetworkServiceLocator().networkClient(config: config);

  static TokenStorage tokenStorage() => NetworkServiceLocator().tokenStorage();

  static IONIdentityClient identityUserClient({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
  }) {
    return ClientsServiceLocator().ionIdentityClient(
      username: username,
      config: config,
      signer: signer,
    );
  }
}
