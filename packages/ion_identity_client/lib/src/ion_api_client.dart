import 'package:ion_identity_client/src/auth/ion_auth.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets.dart';

class IonApiClient {
  const IonApiClient._({
    required this.auth,
    required this.wallets,
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
      wallets: IonWallets.createDefault(
        config: config,
        signer: signer,
      ),
    );
  }

  final IonAuth auth;
  final IonWallets wallets;
}
