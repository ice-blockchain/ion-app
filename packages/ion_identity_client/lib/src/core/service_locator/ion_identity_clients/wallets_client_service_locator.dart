// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_clients/user_action_signer_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_service_locator.dart';
import 'package:ion_identity_client/src/signer/passkey_signer.dart';
import 'package:ion_identity_client/src/wallets/ion_identity_wallets.dart';
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

class WalletsClientServiceLocator {
  factory WalletsClientServiceLocator() {
    return _instance;
  }

  WalletsClientServiceLocator._internal();

  static final WalletsClientServiceLocator _instance = WalletsClientServiceLocator._internal();

  IONIdentityWallets wallets({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
  }) {
    return IONIdentityWallets(
      username: username,
      createWalletService: createWallet(
        username: username,
        config: config,
        signer: signer,
      ),
      getWalletsService: getWallets(username: username, config: config),
      getWalletAssetsService: getWalletAssets(username: username, config: config),
      getWalletNftsService: getWalletNfts(username: username, config: config),
      getWalletHistoryService: getWalletHistory(username: username, config: config),
      getWalletTransferRequestsService: getWalletTransferRequests(
        username: username,
        config: config,
      ),
      generateSignatureService: generateSignature(
        username: username,
        config: config,
        signer: signer,
      ),
    );
  }

  CreateWalletService createWallet({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
  }) {
    return CreateWalletService(
      username: username,
      dataSource: const CreateWalletDataSource(),
      userActionSigner: UserActionSignerServiceLocator().userActionSigner(
        config: config,
        signer: signer,
      ),
    );
  }

  GetWalletsService getWallets({
    required String username,
    required IONIdentityConfig config,
  }) {
    return GetWalletsService(
      username,
      GetWalletsDataSource(
        IONIdentityServiceLocator.networkClient(config: config),
        IONIdentityServiceLocator.tokenStorage(),
      ),
    );
  }

  GetWalletAssetsService getWalletAssets({
    required String username,
    required IONIdentityConfig config,
  }) {
    return GetWalletAssetsService(
      username,
      GetWalletAssetsDataSource(
        IONIdentityServiceLocator.networkClient(config: config),
        IONIdentityServiceLocator.tokenStorage(),
      ),
    );
  }

  GetWalletNftsService getWalletNfts({
    required String username,
    required IONIdentityConfig config,
  }) {
    return GetWalletNftsService(
      username,
      GetWalletNftsDataSource(
        IONIdentityServiceLocator.networkClient(config: config),
        IONIdentityServiceLocator.tokenStorage(),
      ),
    );
  }

  GetWalletHistoryService getWalletHistory({
    required String username,
    required IONIdentityConfig config,
  }) {
    return GetWalletHistoryService(
      username,
      GetWalletHistoryDataSource(
        IONIdentityServiceLocator.networkClient(config: config),
        IONIdentityServiceLocator.tokenStorage(),
      ),
    );
  }

  GetWalletTransferRequestsService getWalletTransferRequests({
    required String username,
    required IONIdentityConfig config,
  }) {
    return GetWalletTransferRequestsService(
      username,
      GetWalletTransferRequestsDataSource(
        IONIdentityServiceLocator.networkClient(config: config),
        IONIdentityServiceLocator.tokenStorage(),
      ),
    );
  }

  PseudoNetworkGenerateSignatureService generateSignature({
    required String username,
    required IONIdentityConfig config,
    required PasskeysSigner signer,
  }) {
    return PseudoNetworkGenerateSignatureService(
      username: username,
      dataSource: const PseudoNetworkGenerateSignatureDataSource(),
      userActionSigner: UserActionSignerServiceLocator().userActionSigner(
        config: config,
        signer: signer,
      ),
    );
  }
}
