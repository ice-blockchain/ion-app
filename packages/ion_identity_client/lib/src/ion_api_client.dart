import 'package:ion_identity_client/src/auth/ion_auth.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class IonApiClient {
  final IonAuth auth;

  const IonApiClient._({
    required this.auth,
  });

  factory IonApiClient.createDefault({
    required String appId,
    required String apiKey,
  }) {
    final config = IonClientConfig(appId: appId, apiKey: apiKey);
    final signer = PasskeysSigner();

    return IonApiClient._(
      auth: IonAuth.createDefault(
        config: config,
        signer: signer,
      ),
    );
  }
}
