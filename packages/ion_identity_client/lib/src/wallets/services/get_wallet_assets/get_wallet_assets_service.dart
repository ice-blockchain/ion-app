// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/data_sources/get_wallet_assets_data_source.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/result_types/get_wallet_assets_result.dart';

class GetWalletAssetsService {
  const GetWalletAssetsService(
    this.username,
    this._getWalletAssetsDataSource,
  );

  final String username;
  final GetWalletAssetsDataSource _getWalletAssetsDataSource;

  Future<GetWalletAssetsResult> getWalletAssets(String walletId) async {
    final response = await _getWalletAssetsDataSource.getWalletAssets(username, walletId).run();

    return response.fold(
      GetWalletAssetsResult.failure,
      GetWalletAssetsResult.success,
    );
  }
}
