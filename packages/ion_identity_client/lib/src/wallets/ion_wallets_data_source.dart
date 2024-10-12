// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/network/network.dart';
import 'package:ion_identity_client/src/core/token_storage/token_storage.dart';
import 'package:ion_identity_client/src/core/types/http_method.dart';
import 'package:ion_identity_client/src/ion_client_config.dart';
import 'package:ion_identity_client/src/signer/types/user_action_signing_request.dart';
import 'package:ion_identity_client/src/wallets/dtos/create_wallet_request.dart';

class IonWalletsDataSource {
  IonWalletsDataSource({
    required this.config,
    required this.networkClient,
    required this.tokenStorage,
  });

  static const listWalletsPath = '/wallets';
  static const createWalletPath = '/wallets';

  final IonClientConfig config;
  final NetworkClient networkClient;
  final TokenStorage tokenStorage;

  UserActionSigningRequest buildCreateWalletSigningRequest({
    required String username,
    required String network,
    required String name,
  }) {
    return UserActionSigningRequest(
      username: username,
      method: HttpMethod.post,
      path: createWalletPath,
      body: CreateWalletRequest(
        network: network,
        name: name,
      ).toJson(),
    );
  }
}
