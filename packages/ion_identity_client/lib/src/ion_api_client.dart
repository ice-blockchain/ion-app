import 'package:ion_identity_client/src/auth/utils/token_storage.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_service_locator.dart';
import 'package:ion_identity_client/src/ion_api_user_client.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';

class IonApiClient {
  IonApiClient._({
    required IonClientConfig config,
    required PasskeysSigner signer,
    required TokenStorage tokenStorage,
  })  : _config = config,
        _signer = signer,
        _tokenStorage = tokenStorage;

  factory IonApiClient.createDefault({
    required IonClientConfig config,
  }) {
    final signer = PasskeysSigner();

    return IonApiClient._(
      config: config,
      signer: signer,
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  IonApiUserClient call({
    required String username,
  }) {
    return IonServiceLocator.getApiClient(
      username: username,
      config: _config,
      signer: _signer,
    );
  }

  final IonClientConfig _config;
  final PasskeysSigner _signer;
  final TokenStorage _tokenStorage;

  Stream<Iterable<String>> get authorizedUsers => _tokenStorage.userTokens.map(
        (list) => list.map(
          (e) => e.username,
        ),
      );
}
