// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/data_sources/data_sources.dart';
import 'package:ion_identity_client/src/auth/data_sources/recover_user_data_source.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/auth/services/recover_user_service.dart';
import 'package:ion_identity_client/src/auth/services/services.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_service_locator.dart';
import 'package:ion_identity_client/src/ion_api_user_client.dart';
import 'package:ion_identity_client/src/signer/data_sources/user_action_signer_data_source.dart';
import 'package:ion_identity_client/src/signer/data_sources/user_action_signer_data_source2.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/signer/user_action_signer2.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets.dart';
import 'package:ion_identity_client/src/wallets/services/create_wallet/create_wallet_service.dart';
import 'package:ion_identity_client/src/wallets/services/create_wallet/data_sources/create_wallet_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/data_sources/get_wallet_assets_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/get_wallet_assets_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/data_sources/get_wallet_history_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/get_wallet_history_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/data_sources/get_wallet_nfts_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/get_wallet_nfts_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/data_sources/get_wallets_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/get_wallets_service.dart';

class ClientsServiceLocator with _IonClient, _AuthClient, _WalletsClient, _UserActionSigner {
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
      registerService: createRegisterService(username: username, config: config, signer: signer),
      loginService: createLoginService(username: username, config: config, signer: signer),
      createRecoveryCredentialsService: createCreateRecoveryCredentialsService(
        username: username,
        config: config,
        signer: signer,
      ),
      recoverUserService: createRecoverUserService(
        username: username,
        config: config,
        signer: signer,
      ),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  RegisterService createRegisterService({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return RegisterService(
      username: username,
      signer: signer,
      dataSource: createRegisterDataSource(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  RegisterDataSource createRegisterDataSource({
    required IonClientConfig config,
  }) {
    return RegisterDataSource(
      networkClient: IonServiceLocator.getNetworkClient(config: config),
    );
  }

  LoginService createLoginService({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return LoginService(
      username: username,
      signer: signer,
      dataSource: createLoginDataSource(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  LoginDataSource createLoginDataSource({
    required IonClientConfig config,
  }) {
    return LoginDataSource(
      networkClient: IonServiceLocator.getNetworkClient(config: config),
    );
  }

  CreateRecoveryCredentialsService createCreateRecoveryCredentialsService({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return CreateRecoveryCredentialsService(
      username: username,
      config: config,
      dataSource: createCreateRecoveryCredentialsDataSource(config: config),
      userActionSigner: ClientsServiceLocator().createUserActionSigner(
        config: config,
        signer: signer,
      ),
      keyService: const KeyService(),
    );
  }

  CreateRecoveryCredentialsDataSource createCreateRecoveryCredentialsDataSource({
    required IonClientConfig config,
  }) {
    return CreateRecoveryCredentialsDataSource(
      networkClient: IonServiceLocator.getNetworkClient(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  RecoverUserService createRecoverUserService({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return RecoverUserService(
      config: config,
      username: username,
      passkeySigner: signer,
      dataSource: createRecoverUserDataSource(config: config),
      keyService: const KeyService(),
    );
  }

  RecoverUserDataSource createRecoverUserDataSource({
    required IonClientConfig config,
  }) {
    return RecoverUserDataSource(
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
      createWalletService: createCreateWalletService(
        username: username,
        config: config,
        signer: signer,
      ),
      getWalletsService: createGetWalletsService(username: username, config: config),
      getWalletAssetsService: createGetWalletAssetsService(username: username, config: config),
      getWalletNftsService: createGetWalletNftsService(username: username, config: config),
      getWalletHistoryService: createGetWalletHistoryService(username: username, config: config),
    );
  }

  CreateWalletService createCreateWalletService({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return CreateWalletService(
      username: username,
      dataSource: const CreateWalletDataSource(),
      userActionSigner: ClientsServiceLocator().createUserActionSigner2(
        config: config,
        signer: signer,
      ),
    );
  }

  GetWalletsService createGetWalletsService({
    required String username,
    required IonClientConfig config,
  }) {
    return GetWalletsService(
      username,
      createGetWalletsDataSource(config: config),
    );
  }

  GetWalletsDataSource createGetWalletsDataSource({
    required IonClientConfig config,
  }) {
    return GetWalletsDataSource(
      IonServiceLocator.getNetworkClient2(config: config),
      IonServiceLocator.getTokenStorage(),
    );
  }

  GetWalletAssetsService createGetWalletAssetsService({
    required String username,
    required IonClientConfig config,
  }) {
    return GetWalletAssetsService(
      username,
      createGetWalletAssetsDataSource(config),
    );
  }

  GetWalletAssetsDataSource createGetWalletAssetsDataSource(IonClientConfig config) {
    return GetWalletAssetsDataSource(
      IonServiceLocator.getNetworkClient2(config: config),
      IonServiceLocator.getTokenStorage(),
    );
  }

  GetWalletNftsService createGetWalletNftsService({
    required String username,
    required IonClientConfig config,
  }) {
    return GetWalletNftsService(
      username,
      createGetWalletNftsDataSource(config),
    );
  }

  GetWalletNftsDataSource createGetWalletNftsDataSource(IonClientConfig config) {
    return GetWalletNftsDataSource(
      IonServiceLocator.getNetworkClient2(config: config),
      IonServiceLocator.getTokenStorage(),
    );
  }

  GetWalletHistoryService createGetWalletHistoryService({
    required String username,
    required IonClientConfig config,
  }) {
    return GetWalletHistoryService(
      username,
      createGetWalletHistoryDataSource(config),
    );
  }

  GetWalletHistoryDataSource createGetWalletHistoryDataSource(IonClientConfig config) {
    return GetWalletHistoryDataSource(
      IonServiceLocator.getNetworkClient2(config: config),
      IonServiceLocator.getTokenStorage(),
    );
  }
}

mixin _UserActionSigner {
  UserActionSigner createUserActionSigner({
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return UserActionSigner(
      dataSource: createUserActionSignerDataSource(config: config),
      passkeysSigner: signer,
    );
  }

  UserActionSignerDataSource createUserActionSignerDataSource({
    required IonClientConfig config,
  }) {
    return UserActionSignerDataSource(
      networkClient: IonServiceLocator.getNetworkClient(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  UserActionSigner2 createUserActionSigner2({
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return UserActionSigner2(
      dataSource: createUserActionSignerDataSource2(config: config),
      passkeysSigner: signer,
    );
  }

  UserActionSignerDataSource2 createUserActionSignerDataSource2({
    required IonClientConfig config,
  }) {
    return UserActionSignerDataSource2(
      networkClient: IonServiceLocator.getNetworkClient2(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }
}
