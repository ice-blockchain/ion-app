import 'package:dio/dio.dart';
import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/utils/network_service_locator.dart';

class IonServiceLocator {
  static Dio getDio({
    required IonClientConfig config,
  }) =>
      NetworkServiceLocator.getDio(config: config);

  static TokenStorage getTokenStorage() => NetworkServiceLocator.getTokenStorage();
}
