// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/auth/services/create_recovery_credentials/create_recovery_credentials_service.dart';
import 'package:ion_identity_client/src/auth/services/create_recovery_credentials/data_sources/create_recovery_credentials_data_source.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/data_sources/delegated_login_data_source.dart';
import 'package:ion_identity_client/src/auth/services/delegated_login/delegated_login_service.dart';
import 'package:ion_identity_client/src/auth/services/key_service.dart';
import 'package:ion_identity_client/src/auth/services/login/data_sources/login_data_source.dart';
import 'package:ion_identity_client/src/auth/services/login/login_service.dart';
import 'package:ion_identity_client/src/auth/services/recover_user/data_sources/recover_user_data_source.dart';
import 'package:ion_identity_client/src/auth/services/recover_user/recover_user_service.dart';
import 'package:ion_identity_client/src/auth/services/register/data_sources/register_data_source.dart';
import 'package:ion_identity_client/src/auth/services/register/register_service.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_clients/users_client_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_service_locator.dart';
import 'package:ion_identity_client/src/ion_api_user_client.dart';
import 'package:ion_identity_client/src/signer/data_sources/user_action_signer_data_source.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';
import 'package:ion_identity_client/src/wallets/ion_wallets.dart';
import 'package:ion_identity_client/src/wallets/services/create_wallet/create_wallet_service.dart';
import 'package:ion_identity_client/src/wallets/services/create_wallet/data_sources/create_wallet_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/data_sources/get_wallet_assets_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/get_wallet_assets_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/data_sources/get_wallet_history_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/get_wallet_history_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/data_sources/get_wallet_nfts_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/get_wallet_nfts_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/data_sources/get_wallet_transfer_requests_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/get_wallet_transfer_requests_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/data_sources/get_wallets_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/get_wallets_service.dart';
import 'package:ion_identity_client/src/wallets/services/pseudo_network_generate_signature/data_sources/pseudo_network_generate_signature_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/pseudo_network_generate_signature/pseudo_network_generate_signature_service.dart';

class ClientsServiceLocator
    with _IonClient, _AuthClient, _WalletsClient, _UserActionSigner, UsersClientServiceLocator {
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
        users: ClientsServiceLocator().users(
          username: username,
          config: config,
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
      delegatedLoginService: createDelegatedLoginService(config: config),
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
      userActionSigner: ClientsServiceLocator().createUserActionSigner2(
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

  DelegatedLoginService createDelegatedLoginService({
    required IonClientConfig config,
  }) {
    return DelegatedLoginService(
      dataSource: createDelegatedLoginDataSource(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }

  DelegatedLoginDataSource createDelegatedLoginDataSource({
    required IonClientConfig config,
  }) {
    return DelegatedLoginDataSource(
      networkClient: IonServiceLocator.getNetworkClient(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
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
      getWalletTransferRequestsService: createGetWalletTransferRequestsService(
        username: username,
        config: config,
      ),
      generateSignatureService: createGenerateSignatureService(
        username: username,
        config: config,
        signer: signer,
      ),
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
      IonServiceLocator.getNetworkClient(config: config),
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
      IonServiceLocator.getNetworkClient(config: config),
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
      IonServiceLocator.getNetworkClient(config: config),
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
      IonServiceLocator.getNetworkClient(config: config),
      IonServiceLocator.getTokenStorage(),
    );
  }

  GetWalletTransferRequestsService createGetWalletTransferRequestsService({
    required String username,
    required IonClientConfig config,
  }) {
    return GetWalletTransferRequestsService(
      username,
      createGetWalletTransferRequestsDataSource(config),
    );
  }

  GetWalletTransferRequestsDataSource createGetWalletTransferRequestsDataSource(
    IonClientConfig config,
  ) {
    return GetWalletTransferRequestsDataSource(
      IonServiceLocator.getNetworkClient(config: config),
      IonServiceLocator.getTokenStorage(),
    );
  }

  PseudoNetworkGenerateSignatureService createGenerateSignatureService({
    required String username,
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return PseudoNetworkGenerateSignatureService(
      username: username,
      dataSource: createGenerateSignatureDataSource(),
      userActionSigner: ClientsServiceLocator().createUserActionSigner2(
        config: config,
        signer: signer,
      ),
    );
  }

  PseudoNetworkGenerateSignatureDataSource createGenerateSignatureDataSource() {
    return const PseudoNetworkGenerateSignatureDataSource();
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

  UserActionSigner createUserActionSigner2({
    required IonClientConfig config,
    required PasskeysSigner signer,
  }) {
    return UserActionSigner(
      dataSource: createUserActionSignerDataSource2(config: config),
      passkeysSigner: signer,
    );
  }

  UserActionSignerDataSource createUserActionSignerDataSource2({
    required IonClientConfig config,
  }) {
    return UserActionSignerDataSource(
      networkClient: IonServiceLocator.getNetworkClient(config: config),
      tokenStorage: IonServiceLocator.getTokenStorage(),
    );
  }
}
