// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/data_sources/get_wallet_assets_data_source.dart';

class GetWalletAssetsService {
  const GetWalletAssetsService(
    this.username,
    this._getWalletAssetsDataSource,
  );

  final String username;
  final GetWalletAssetsDataSource _getWalletAssetsDataSource;

  Future<WalletAssets> getWalletAssets(String walletId) async {
    return _getWalletAssetsDataSource.getWalletAssets(username, walletId);
  }
}
