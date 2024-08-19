import 'package:ion_identity_client/src/core/service_locator/ion_service_locator.dart';
import 'package:ion_identity_client/src/ion_api_user_client.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class IonApiClient {
  const IonApiClient._({
    required this.config,
    required this.signer,
  });

  factory IonApiClient.createDefault({
    required IonClientConfig config,
  }) {
    final signer = PasskeysSigner();

    return IonApiClient._(
      config: config,
      signer: signer,
    );
  }

  IonApiUserClient call({
    required String username,
  }) {
    return IonServiceLocator.getApiClient(
      username: username,
      config: config,
      signer: signer,
    );
  }

  final IonClientConfig config;
  final PasskeysSigner signer;
}
