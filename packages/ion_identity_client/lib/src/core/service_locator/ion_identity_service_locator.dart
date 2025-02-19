// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/service_locator/clients_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/network_service_locator.dart';
import 'package:ion_identity_client/src/core/storage/biometrics_state_storage.dart';
import 'package:ion_identity_client/src/core/storage/local_passkey_creds_state_storage.dart';
import 'package:ion_identity_client/src/core/storage/private_key_storage.dart';
import 'package:ion_identity_client/src/core/storage/token_storage.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';

class IONIdentityServiceLocator {
  static NetworkClient networkClient({
    required IONIdentityConfig config,
  }) =>
      NetworkServiceLocator().networkClient(config: config);

  static TokenStorage tokenStorage() => NetworkServiceLocator().tokenStorage();

  static PrivateKeyStorage privateKeyStorage() => NetworkServiceLocator().privateKeyStorage();

  static BiometricsStateStorage biometricsStateStorage() =>
      NetworkServiceLocator().biometricsStateStorage();

  static LocalPasskeyCredsStateStorage localPasskeyCredsStateStorage() =>
      NetworkServiceLocator().localPasskeyCredsStateStorage();

  static IONIdentityClient identityUserClient({
    required String username,
    required IONIdentityConfig config,
    required IdentitySigner identitySigner,
  }) {
    return ClientsServiceLocator().ionIdentityClient(
      username: username,
      config: config,
      identitySigner: identitySigner,
    );
  }
}
