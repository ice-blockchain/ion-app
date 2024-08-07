import 'package:ion_identity_client/src/auth/ion_auth_data_source.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class IonAuth {
  IonAuth._({
    required this.config,
    required this.dataSource,
    required this.signer,
  });

  factory IonAuth.createDefault({
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return IonAuth._(
      config: config,
      signer: signer,
      dataSource: IonAuthDataSource.createDefault(),
    );
  }

  final IonClientConfig config;
  final IonAuthDataSource dataSource;
  final PasskeysSigner signer;

  Future<void> registerUser(String username) async {
    final initResponse = await dataSource.registerInit(
      appId: config.appId,
      username: username,
    );

    final attestation = await signer.register(initResponse);

    dataSource.registerComplete(
      appId: config.appId,
      attestation: attestation,
      temporaryAuthenticationToken: initResponse.temporaryAuthenticationToken,
    );
  }
}
