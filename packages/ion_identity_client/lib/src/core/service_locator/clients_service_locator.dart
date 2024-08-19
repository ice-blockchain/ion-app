import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/ion_auth_data_source.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_service_locator.dart';
import 'package:ion_identity_client/src/ion_api_user_client.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets_data_source.dart';

class ClientsServiceLocator with _IonClient, _AuthClient, _WalletsClient {
  factory ClientsServiceLocator() {
    return _instance;
  }

  ClientsServiceLocator._internal();

  static final ClientsServiceLocator _instance = ClientsServiceLocator._internal();
}

mixin _IonClient {
  final Map<String, IonApiUserClient> _clients = {};

  IonApiUserClient getIonClient({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    var client = _clients[username];
    if (client == null) {
      client = IonApiUserClient(
        auth: ClientsServiceLocator().createAuthClient(
          username: username,
          config: config,
          signer: signer,
        ),
        wallets: ClientsServiceLocator().createWalletsClient(
          username: username,
          config: config,
          signer: signer,
        ),
      );
      _clients[username] = client;
    }
    return client;
  }
}

mixin _AuthClient {
  IonAuth createAuthClient({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return IonAuth(
      username: username,
      config: config,
      signer: signer,
      dataSource: createAuthDataSource(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  IonAuthDataSource createAuthDataSource({
    required IonClientConfig config,
  }) {
    return IonAuthDataSource(
      config: config,
      networkClient: IonServiceLocator.getNetworkClient(config: config),
    );
  }
}

mixin _WalletsClient {
  IonWallets createWalletsClient({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return IonWallets(
      username: username,
      config: config,
      signer: signer,
      dataSource: createWalletsDataSource(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  IonWalletsDataSource createWalletsDataSource({
    required IonClientConfig config,
  }) {
    final networkClient = IonServiceLocator.getNetworkClient(config: config);

    return IonWalletsDataSource(
      config: config,
      networkClient: networkClient,
    );
  }
}
