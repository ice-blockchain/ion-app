import 'package:ion_identity_client/src/auth/dtos/dtos.dart';
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
      dataSource: IonAuthDataSource.createDefault(
        config: config,
      ),
    );
  }

  final IonClientConfig config;
  final IonAuthDataSource dataSource;
  final PasskeysSigner signer;

  Future<RegistrationCompleteResponse> registerUser({
    required String username,
  }) async {
    final initResponse = await dataSource.registerInit(
      username: username,
    );

    final attestation = await signer.register(initResponse);

    final registerResponse = await dataSource.registerComplete(
      attestation: attestation,
      temporaryAuthenticationToken: initResponse.temporaryAuthenticationToken,
    );

    return registerResponse;
  }
}
