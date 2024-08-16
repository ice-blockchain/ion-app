import 'package:ion_identity_client/src/auth/ion_auth.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class IonApiClient {
  const IonApiClient._({
    required this.auth,
  });

  factory IonApiClient.createDefault({
    required IonClientConfig config,
  }) {
    final signer = PasskeysSigner();

    return IonApiClient._(
      auth: IonAuth.createDefault(
        config: config,
        signer: signer,
      ),
    );
  }

  final IonAuth auth;
}
