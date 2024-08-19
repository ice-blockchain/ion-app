import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/network/network_client.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/utils/network_service_locator.dart';

class IonServiceLocator {
  static NetworkClient getNetworkClient({
    required IonClientConfig config,
  }) =>
      NetworkServiceLocator().getNetworkClient(config: config);

  static TokenStorage getTokenStorage() => NetworkServiceLocator().getTokenStorage();
}
