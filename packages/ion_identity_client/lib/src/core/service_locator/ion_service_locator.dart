// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/core/network2/network_client2.dart';
import 'package:ion_identity_client/src/core/service_locator/clients_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/network_service_locator.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/ion_api_user_client.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class IonServiceLocator {
  static NetworkClient getNetworkClient({
    required IonClientConfig config,
  }) =>
      NetworkServiceLocator().getNetworkClient(config: config);

  static NetworkClient2 getNetworkClient2({
    required IonClientConfig config,
  }) =>
      NetworkServiceLocator().getNetworkClient2(config: config);

  static TokenStorage getTokenStorage() => NetworkServiceLocator().getTokenStorage();

  static IonApiUserClient getApiClient({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return ClientsServiceLocator().getIonClient(
      username: username,
      config: config,
      signer: signer,
    );
  }
}
